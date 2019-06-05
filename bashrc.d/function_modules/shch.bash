#!/usr/bin/env bash
# shch

if command -v shellcheck > /dev/null; then
    shch () {
        #shellcheck disable=2154
        while read -r LINE; do hr; echo ">>> ${LINE}"; if [[ -r "${LINE}" ]]; then shellcheck -x "${LINE}"; else __reportErr "file not found -- ${LINE}"; fi; done < <(find "${bashenv}" -mindepth 1 -not -path "*/.git/*" -type f -not -name "*.swp" -not -name ".*"); hr -t
        return
    }
fi
