#!/usr/bin/env bash
# hr

hr ()
{
    local defaultDelim delim str
    defaultDelim='.'
    str=

    delim="${1:-$defaultDelim}"

    _buildHRString ()
    {
        [[ -z "${delim:-}" ]] \
            && delim="${defaultDelim}"
        for ((c=0;c<$(tput cols);c++)); do
            str+="${delim}"
        done

        return
    }

    if [[ -z "${HRSTR:-}" ]]; then
        _buildHRString
        export HRSTR="${str}"
    else
        if [[ ! "${delim}" == "${HRSTR:0:1}" ]]; then
            HRSTR=
            _buildHRString
            export HRSTR="${str}"
        elif (( ${#HRSTR} != $(tput cols) )); then
            delim="${HRSTR:0:1}"
            HRSTR=
            _buildHRString
            export HRSTR="${str}"
        fi

    fi

    echo -en "${HRSTR}\\n"

    return
}
