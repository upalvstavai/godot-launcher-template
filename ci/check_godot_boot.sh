#!/usr/bin/env bash
set -uo pipefail

if (( $# == 0 )); then
	echo "usage: $0 GODOT_COMMAND [ARG ...]" >&2
	exit 2
fi

log_file="$(mktemp)"
trap 'rm -f "$log_file"' EXIT

"$@" 2>&1 | tee "$log_file"
command_status=${PIPESTATUS[0]}
if (( command_status != 0 )); then
	exit "$command_status"
fi

if grep -Eq '^(SCRIPT ERROR|ERROR):' "$log_file"; then
	echo "Godot logged an error while booting." >&2
	exit 1
fi
