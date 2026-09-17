#!/bin/sh
set -eu

local_dir="$PWD/.local"
ignore_file="$local_dir/.gitignore"

dir_result=exists
if [ ! -d "$local_dir" ]; then
  mkdir -p "$local_dir"
  dir_result=created
fi

ignore_result=exists
if [ ! -f "$ignore_file" ]; then
  printf '*\n' > "$ignore_file"
  ignore_result=created
elif ! grep -Fxq '*' "$ignore_file"; then
  [ ! -s "$ignore_file" ] || printf '\n' >> "$ignore_file"
  printf '*\n' >> "$ignore_file"
  ignore_result=updated
fi

printf '.local: %s\n.local/.gitignore: %s\nready: %s\n' "$dir_result" "$ignore_result" "$local_dir"
