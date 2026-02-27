#!/usr/bin/env bash
set -euo pipefail

argument_count=$#
if [[ $argument_count -ne 0 ]]; then
  echo "This script does not accept arguments." >&2
  exit 2
fi

script_directory=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
repository_root=$(cd "$script_directory/.." && pwd)
cd "$repository_root"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "This script must run inside a git repository." >&2
  exit 1
fi

changed_files=$(
  {
    git diff --name-only --cached
    git diff --name-only
    git ls-files --others --exclude-standard
  } | sed '/^$/d' | sort -u
)

if [[ -z "$changed_files" ]]; then
  echo "No local changes detected."
  exit 0
fi

needs_swiftplaygrounds_build=false
needs_vapor_server_build=false

if grep -Eq '^(SwiftPlaygrounds/|SwiftPlaygrounds\.xcodeproj/|ci_scripts/)' <<<"$changed_files"; then
  needs_swiftplaygrounds_build=true
fi

if grep -Eq '^VaporServer/' <<<"$changed_files"; then
  needs_vapor_server_build=true
fi

if ! $needs_swiftplaygrounds_build && ! $needs_vapor_server_build; then
  echo "No changes that require configured builds."
  exit 0
fi

if $needs_swiftplaygrounds_build; then
  echo "Running SwiftPlaygrounds build."
  bash ci_scripts/build_swiftplaygrounds.sh
fi

if $needs_vapor_server_build; then
  echo "Running VaporServer build."
  bash ci_scripts/build_vapor_server.sh
fi
