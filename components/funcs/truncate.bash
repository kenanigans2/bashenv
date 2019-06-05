#!/usr/bin/env bash
# truncate

truncate ()
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

    echo -e "${input}" | cut -c1-"$(tput cols)"
    
    echo "COLS: $(tput cols)"
    return
}
