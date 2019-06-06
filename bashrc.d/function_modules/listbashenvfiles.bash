#!/usr/bin/env bash
# listBashEnvFiles


listbashenvfiles () {
    [[ -z "${bashenv:-}" ]] && return 10
    mapfile -d"\n" bashenvFiles < <( \
        find "${bashenv}" \
            -mindepth 1 \
            -type f \
            \! \( \
                -path "*/.git/*" \
                -or -name ".*" \
                -or -name "*.swp" \
            \) \
        )

    if (( $# == 0 )); then
        # no formatting
        for f in "${bashenvFiles[@]}"; do
            echo "${f}"
        done
    else
        # print formatted
        __printHeading "BASHENV FILES (${#bashenvFiles[@]}):"
        for f in "${bashenvFiles[@]}"; do
            echo -e "\\t- ${f}"
        done
    fi
    return
}
