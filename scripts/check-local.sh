#!/bin/sh
set -eu

local_dir="$PWD/.local"
ignore_file="$local_dir/.gitignore"

if [ ! -d "$local_dir" ]; then
  printf 'missing: %s\n' "$local_dir" >&2
  exit 1
fi

if [ ! -f "$ignore_file" ]; then
  printf 'missing: %s\n' "$ignore_file" >&2
  exit 1
fi

if ! grep -Fxq '*' "$ignore_file"; then
  printf 'invalid: %s must contain a standalone * line\n' "$ignore_file" >&2
  exit 1
fi

printf 'ready: %s\n' "$local_dir"
