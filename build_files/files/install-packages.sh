#!/usr/bin/env bash
set -euo pipefail

package_file="${1:-}"
package_cmd="${2:-}"

log() {
  echo "[install-packages.sh] $*"
}

if [[ -z "$package_file" || -z "$package_cmd" ]]; then
	echo "Usage: $0 <package-file> <command>" >&2
	exit 1
fi

if [[ -f "$package_file" ]]; then
	log "Installing packages from $package_file using $package_cmd"
	while IFS= read -r line; do
		line_no_comment="${line%%#*}"
		line_no_comment="${line_no_comment#${line_no_comment%%[![:space:]]*}}"
		line_no_comment="${line_no_comment%${line_no_comment##*[![:space:]]}}"

		if [[ -n "$line_no_comment" ]]; then
			for package in $line_no_comment; do
				log "Installing $package"
				"$package_cmd" "$package" || log "Failed to install $package, continuing with next package"
			done
		fi
	done < "$package_file"
else
	log "No $package_file found, skipping package installation"
fi

