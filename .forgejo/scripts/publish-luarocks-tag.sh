#!/usr/bin/env bash

set -euo pipefail

[ -n "${LUAROCKS_API_KEY:-}" ] || {
  echo "LUAROCKS_API_KEY is not set" >&2
  exit 1
}

package="${GITHUB_REPOSITORY#*/}"
repo_url="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}"
ref_name="${GITHUB_REF_NAME:-}"
ref_type="${GITHUB_REF_TYPE:-}"

case "${GITHUB_REF:-}" in
  refs/tags/*)
    ref_name="${GITHUB_REF#refs/tags/}"
    ref_type="tag"
    ;;
esac

if [ -z "$ref_name" ] || [ "$ref_type" != "tag" ]; then
  echo "LuaRocks publish must run from a tag ref" >&2
  exit 1
fi

version="${ref_name#v}"
case "$version" in
  ""|*[!0-9.]*)
    echo "LuaRocks publish tag must be vX.Y.Z; got ${ref_name}" >&2
    exit 1
    ;;
esac

rock_version="${version}-1"
rockspec="${package}-${rock_version}.rockspec"
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
version = '$(lua_quote "$rock_version")'

description = {
  summary = '$(lua_quote "$summary")',
  homepage = '$(lua_quote "$repo_url")',
  license = 'GPL-3.0',
}

dependencies = {
  'lua >= 5.1',
}

source = {
  url = '$(lua_quote "$repo_url")/archive/$(lua_quote "$ref_name").zip',
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
    echo "LuaRocks release ${rock_version} already exists; continuing."
  else
    printf "%s\n" "$upload_output" >&2
    exit 1
  fi
else
  printf "%s\n" "$upload_output"
fi

for attempt in $(seq 1 18); do
  rm -rf "$tmpdir/remote"
  if luarocks install --tree "$tmpdir/remote" "$package" "$version"; then
    exit 0
  fi
  rm -rf "$tmpdir/remote"
  if luarocks install --tree "$tmpdir/remote" --server=https://luarocks.org/manifests/barrettruth "$package" "$version"; then
    exit 0
  fi
  echo "Waiting for LuaRocks manifests to include ${package} ${rock_version} (attempt ${attempt}/18)."
  sleep 10
done

echo "Timed out waiting for LuaRocks manifests to include ${package} ${rock_version}." >&2
exit 1
