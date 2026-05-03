#!/usr/bin/env bash

set -euo pipefail

[ -n "${LUAROCKS_API_KEY:-}" ] || {
  echo "LUAROCKS_API_KEY is not set" >&2
  exit 1
}

package="${GITHUB_REPOSITORY#*/}"
repo_url="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}"
sha="${GITHUB_SHA:?}"
short_sha="$(git rev-parse --short=7 "$sha")"
specrev="$(git rev-list --count "$sha")"
rockspec="${package}-scm-${specrev}.rockspec"
summary="$(sed -n "s/.*summary = '\([^']*\)'.*/\1/p" "${package}-scm-1.rockspec" | head -n 1)"

if [ -z "$summary" ]; then
  summary="$package"
fi

lua_quote() {
  printf "%s" "$1" | sed "s/'/\\\\'/g"
}

copy_directories=""
for path in \
  after autoload colors compiler doc filetype.lua ftdetect ftplugin indent \
  keymap lang lsp menu.vim parser parser-info plugin queries query rplugin \
  spell syntax; do
  if [ -e "$path" ]; then
    quoted="'$(lua_quote "$path")'"
    copy_directories="${copy_directories}${copy_directories:+, }${quoted}"
  fi
done

cat >"$rockspec" <<EOF
rockspec_format = '3.0'
package = '$(lua_quote "$package")'
version = 'scm-${specrev}'

description = {
  summary = '$(lua_quote "$summary")',
  homepage = '$(lua_quote "$repo_url")',
  license = 'GPL-3.0',
}

dependencies = {
  'lua >= 5.1',
}

source = {
  url = '$(lua_quote "$repo_url")/archive/${sha}.zip',
  dir = '$(lua_quote "$package")',
}

build = {
  type = 'builtin',
  copy_directories = { ${copy_directories} },
}
EOF

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

luarocks install --tree "$tmpdir/local" "$rockspec"

if ! upload_output="$(luarocks upload "$rockspec" --api-key "$LUAROCKS_API_KEY" 2>&1)"; then
  if printf "%s\n" "$upload_output" | grep -qi "already exists"; then
    printf "%s\n" "$upload_output"
    echo "LuaRocks nightly scm-${specrev} already exists for ${short_sha}; continuing."
  else
    printf "%s\n" "$upload_output" >&2
    exit 1
  fi
else
  printf "%s\n" "$upload_output"
fi

for attempt in $(seq 1 12); do
  if luarocks install --tree "$tmpdir/remote" --server=https://luarocks.org/dev "$package" scm; then
    exit 0
  fi
  echo "Waiting for LuaRocks dev manifest to include ${package} scm-${specrev} (attempt ${attempt}/12)."
  sleep 10
done

echo "Timed out waiting for LuaRocks dev manifest to include ${package} scm-${specrev}." >&2
exit 1
