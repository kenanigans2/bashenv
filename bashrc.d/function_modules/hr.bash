#!/usr/bin/env bash
# hr

hr () {
    local DELIM
    local -i COLS LEADINGLINE TRAILINGLINE OPTIND
    OPTIND=1
    COLS=$(tput cols)
    LEADINGLINE=1 TRAILINGLINE=1

    while getopts :lt opt; do
        case ${opt} in
            l) LEADINGLINE=0;;
            t) TRAILINGLINE=0;;
            \?) continue;;
        esac
    done
    shift $((OPTIND-1))

    DELIM="${1:-.}"

    ___hr_buildHRSTR () {
        for ((c=0;c<COLS;c++)); do
            HRSTR+="${DELIM:?}"
        done
    }

    ___hr_outputString () {
        local STRING="$*"
        (( LEADINGLINE == 0 )) \
            && STRING="\\n${STRING}"
        (( TRAILINGLINE == 0 )) \
            && STRING="${STRING}\\n"
        echo -e "${STRING}"
        return
    }

    if [[ -n "${HRSTR:-}" ]]; then
        if [[ "${HRSTR:0:1}" == "${DELIM:?}" ]]; then
            #
            #-:CASE: HRSTR = DELIM, OUTPUT STRING
            ___hr_outputString "${HRSTR}"
        else
            #
            #-:CASE: HRSTR != DELIM, REBUILD STRING AND OUTPUT
            export HRSTR=''
            ___hr_buildHRSTR
            export HRSTR
            ___hr_outputString "${HRSTR}"
        fi
        return
    else
        #
        #-:CASE: `$HRSTR' IS NULL
        #
        #-:BUILD HRSTR
        ___hr_buildHRSTR
        ___hr_outputString "${HRSTR}"
    fi

    return
}
