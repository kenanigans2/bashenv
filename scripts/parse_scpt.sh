#!/usr/bin/env bash
# parse_scpt

main ()
{
    {
        [[ -n "${funcs:-}" && -d "${funcs:?}" && -x "${funcs:?}" ]] \
            && . "${funcs}/hr.bash"
    } \
        2> /dev/null

    local -r H1COLOR=$'\\\\033[45;37;1m'
    local -r COLORRST=$'\\\\033[0;0m'
    local -r SPANINPUTCOLOR=$'\\\\033[46;30;1m'
    [[ -f "${tmpfileOUT}" \
        && -f "${tmpfileOUT}" ]] \
        || return 21
    local output=
    output="$(process_output)"
    cat <<-. > "${tmpfileOUT}"
        $(hr)
        $(echo -e "\\n${H1COLOR} APPLESCRIPT INPUT ${inputFrom:+(from ${inputFrom#* })}: ${COLORRST}${SPANINPUTCOLOR}${input}${COLORRST}\\n" \
            | sed -e "s:}$:&${COLORRST}:" -e 's:  *[^[:blank:]]*::' \
            | fmt -w $(($(tput cols)-8)) \
            | sed 's:^:	:'\
        )
        $(echo -e "${output}")
.
    while read -r LINE; do echo -e "${LINE}"; done < "${tmpfileOUT}" \
        | sed '2,$s:^:	:' \
        | sed '$a\
        \
        '
    hr
    return
}

process_output ()
{
    {
        cat "${tmpfileIN}" \
            | sed -E -e 's:^[[:blank:]]*{::' -e 's:}[[:blank:]]*$::' \
            | sed -E \
                -e 's:({[0-9]+), ([0-9]+}):\1|\2:g' \
                -e 's:({[0-9]+), ([0-9]+), ([0-9]+), ([0-9]+}):\1|\2|\3|\4:g' \
                -e 's:, :,:g' \
            | tr ',' '\n' \
            | sed -E \
                -e '/:{/s:\|:, :g' \
            | sed -n "w${tmpfileOUT}"
    }
    #
    #
    #
    {
        awk -F":" '
            { printf ("%*s\t%s\n",25,$1,$2)}
        ' \
            < "${tmpfileOUT}" \
                | sed -E \
                    -e "s:true:[32;1m&[0;0m:" \
                    -e "s:false:[31;1m&[0;0m:" \
                    -e "s:	:.....:" \
                    -e 's:^([[:blank:]]+)([^.]+):\1[\2]:' \
                    -e '/^[^[:cntrl:]]+$/s:(\.+)(.*)$:\1[47;30;1m\2[0;0m:' \
                    -e "w${tmpfileOUT}"
    }
    return
}

cleanup ()
{
    local -i errors_occurred=0
    debug_line "cleaning up..."
    for tf in tmpfile{IN,OUT}; do
        debug_line_line="[${tf}]: "
        if [[ ! -f "${tf}" ]]; then
            debug_line_line+="<DELETED>"
        elif [[ -f "${tf}" ]]; then
            debug_line_line+="FOUND - attempting to remove... "
            if
                rm "${tf}" 2> /dev/null
            then
                debug_line_line+="SUCCESS"\! \
            else
                ((errors_occurred+=1))
                debug_line_line+="ERROR: unable to remove tempfile - ${tf}"
            fi
        else
            ((errors_occurred+=1))
            debug_line_line+="unable to find temp file (${tf})"
        fi
        debug_line "${debug_line_line}"
    done \
        | sed '/^[[:blank:]]*$/d'
    return ${errors_occurred}
}

debug_line ()
{
    if (( DEBUGFLAG == 0 )); then
        return 0
    elif (( DEBUGFLAG == 11 )); then
        (( $# < 1 )) \
            && echo "DEBUG LINE: <EMPTY>" >&2 \
            && return 1
        local sender
        local line=
        sender="${FUNCNAME[1]}"
        local -r DEBUGCOLOR=$'[33;1m'
        local -r DEBUGRESET=$'[0;0m'
        local -r DEBUGMSG=$'[44;37;1m'
        line="$(echo "${DEBUGCOLOR}${*}${DEBUGRESET}")"
        line="\\n${DEBUGMSG} DEBUG [${sender:-}]: ${DEBUGRESET}\\n${line}\\n"
        echo -e "${line}" | sed 's:^:	:'
    fi
    return
}

report_err ()
{
    local msg=
    msg="\\n\\t${FUNCNAME[1]}: ERROR - "
    msg+="${*}\\n"
    echo -e "${msg}" >&2
    return
}

prompt_user_for_input ()
{
    local -l REPLY
    local msg=
    msg+="\\nNO INPUT WAS FOUND.\\n"
    msg+="\\nCLIPBOARD: $(pbpaste | tr -d '\n')\\n\\n"
    msg+="IS CLIPBOARD CONTENTS THE TARGET APPLESCRIPT TO PARSE"
    echo -en "${msg}"
    read -rp "? [y/N] " REPLY
    case "${REPLY:0:1}" in
        y)
            inputFrom="clipboard"
            ;;
        *)
            report_err "NO INPUT WAS FOUND."
            return 15
            ;;
    esac
    return
}


#
# DEBUG FLAG
#
{
    declare -i DEBUGFLAG=0
    if [[ "${1:-}" == 'DEBUG' ]]; then
        shift 1
        DEBUGFLAG=11
    fi
}

#
# HANDLE TEMP FILES
#
{
    declare input= tmpfileIN= tmpfileOUT=
    declare -i ppid
    ppid=$(ps -oppid -p${$} | sed -n '2p')
    tmpfileIN="$(mktemp -t "$(basename "${0}").IN.${ppid}-${$}")"
    tmpfileOUT="$(mktemp -t "$(basename "${0}").OUT.${ppid}-${$}")"
    trap 'cleanup' EXIT
    debug_line "$(echo "IN: ${tmpfileIN}\\nOUT: ${tmpfileOUT}" | sed "s:${TMPDIR}:\$TMPDIR/:g")"
}

#
# CAPTURE INPUT
#
{
    declare input= inputFrom=
    if [[ -p /dev/stdin ]]; then
        input="$(cat /dev/stdin)"
        inputFrom="stdin"
    elif (( $# > 0 )); then
        input="${*}"
        inputFrom="args"
    else
        if [[ -n "$(pbpaste)" ]]; then
            input="$(pbpaste)"
            if [[ "${input:0:1}${input: -1}" == '{}' ]]; then
                inputFrom="clipboard"
            else
                prompt_user_for_input \
                    || exit 1
            fi
        fi
    fi
    if [[ "${input:-NULL}" == 'NULL' ]]; then
        report_err "no input was found. Aborting..."
        exit 1
    else
        echo "${input}" > "${tmpfileIN}"
        [[ "${input}" == "$(cat "${tmpfileIN}")" ]] \
            || report_err "an error occurred padding input to INPUT tmpfile (${tmpfileIN})" \
            || exit 2
    fi
}

#
# 1. TEMP FILES CREATED
# 2. INPUT CAPTURED
main

declare -i xit=$?

read -rp "[press ENTER to exit]" REPLY


exit ${xit}


