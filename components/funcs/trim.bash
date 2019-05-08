#!/usr/bin/env bash
# trim

trim ()
{
    local input
    if [[ -p /dev/stdin ]]; then
        input="$(cat /dev/stdin)"
    elif (( $# > 0 )); then
        input="${*}"
    else
        echo "${FUNCNAME[0]}: received no data. Exiting." >&2
        return 1
    fi

    echo "${input}" \
        | sed -e 's:^[[:blank:]]*::' -e 's:[[:blank:]]*$::'

    return
}
