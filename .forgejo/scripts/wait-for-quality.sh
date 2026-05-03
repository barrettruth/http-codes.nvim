#!/usr/bin/env bash
set -eu

required_contexts='quality / Format (push)
quality / Lint (push)'
if grep -q '^  test:' .forgejo/workflows/quality.yaml; then
  required_contexts="${required_contexts}
quality / Test (push)"
fi

deadline="$(($(date +%s) + 3600))"
while [ "$(date +%s)" -lt "$deadline" ]; do
  payload="$(curl -fsSL \
    -H "Authorization: token $GITHUB_TOKEN" \
    "$SERVER_URL/api/v1/repos/$REPOSITORY/commits/$SHA/status")"
  pending=""
  failed=""

  while IFS= read -r context; do
    [ -n "$context" ] || continue
    status="$(printf '%s' "$payload" | jq -r --arg context "$context" '[.statuses[]? | select(.context == $context)][0].status // ""')"
    case "$status" in
      success) ;;
      error | failure) failed="${failed}${failed:+, }${context}" ;;
      *) pending="${pending}${pending:+, }${context}" ;;
    esac
  done <<CONTEXTS
$required_contexts
CONTEXTS

  if [ -n "$failed" ]; then
    echo "Quality checks failed: $failed" >&2
    exit 1
  fi
  if [ -z "$pending" ]; then
    echo "Quality checks passed."
    exit 0
  fi

  echo "Waiting for quality checks: $pending"
  sleep 10
done

echo "Timed out waiting for quality checks." >&2
exit 1
