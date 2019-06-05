#!/usr/bin/env bash
# Darwin config

echo "SYS: macOS"
if [[ -d "${BASH_SOURCE[0]%.*}.d" ]]; then

    [[ -z "${sysConfig:-}" ]] \
        || declare -xr sysConfig="${BASH_SOURCE[0]%.*}.d"

    declare -ax sysConfigFiles
    sysConfigFiles=()

    mapfile sysConfigFiles < <(find "${BASH_SOURCE[0]%.*}.d" -mindepth 1 -maxdepth 1 -type f \
        \! \( -name ".*" -or -name "_*" -or -name "*.swp" \) )

    for f in "${sysConfigFiles[@]}"; do
        f="$(echo "$f" | tr -d '\n')"
        . "$f"
        unset f
    done
    
fi
