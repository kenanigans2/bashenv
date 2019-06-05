#!/usr/bin/env bash
# bash_profile

#
#-:LOAD SHELL CONFIG
[ -r ~/.profile ] && . ~/.profile

__setBashEnvVariables () {
    declare -r ERROR_CLR='[31;1m'
    declare -r CLR_RST='[0;0m'
}

__getBashEnvDir () {
    dirname "$(find "${BASH_SOURCE[0]}" -exec /bin/ls -l {} \; | awk -F" -> " '{print $NF}')"
    return
}

__printHeading () {
    echo -e "\\n${*:?}" \
        | sed 's:^:	:'
    echo
    return
}

__printParagraph () {
    #
    #-:SET INDENT LEVEL
    #   - default=1, option `-i' or `-l' sets to `$OPTARG'
    #
    local msg bulletChar
    local -i OPTIND INDENT_LEVEL LEADING_SPACE TRAILING_SPACE
    msg="${*}" bulletChar=''
    OPTIND=1 INDENT_LEVEL=1 LEADING_SPACE=1 TRAILING_SPACE=1
    while getopts :lti:b: opt; do
        case ${opt} in
            b)
                bulletChar="${OPTARG}"
                ;;
            i)
                #
                #-:SPECIFY INDENT LEVEL
                #   - otherwise, default is 1
                #
                INDENT_LEVEL=${OPTARG}
                ;;
            l)
                #
                #-:SPECIFY LEADING EMPTY LINE
                LEADING_SPACE=0
                ;;
            t)
                #
                #-:SPECIFY TRAILING EMPTY LINE
                TRAILING_SPACE=0
                ;;
            :)
                return 2
                ;;
            \?)
                return 1
                ;;
        esac
    done \
        && shift $((OPTIND-1))
    #
    #-:IF NO ARGS AFTER OPTIONS, ERROR
    (( $# < 1)) && return 2
    #
    #-:SET MSG TO REST OF ARGS
    msg="${*}"
    #
    #-:STRIP LEADING & TRAILNG EMPTY LINES
    [[ "$(echo "${msg:?}" | sed -n '$p')" =~ ^[[:blank:]]*$ ]] \
        && msg="$(echo "${msg}" | sed '$d')"
    [[ "$(echo "${msg:?}" | sed -n '1p')" =~ ^[[:blank:]]*$ ]] \
        && msg="$(echo "${msg}" | sed '1d')"
    #
    #-:PROCESS `$msg' WITH INDENTS
    while ((INDENT_LEVEL > 0)); do
        msg="$(echo "${msg}" | sed "s:^:	${bulletChar:+$bulletChar }:")"
        ((INDENT_LEVEL-=1))
    done
    #
    #-:FORMAT LEADING/TRAILING EMPTY LINES
    (( LEADING_SPACE == 0 )) && msg="\\n${msg}"
    (( TRAILING_SPACE == 0 )) && msg="${msg}\\n"
    #
    #-:OUTPUT `$msg'
    echo -e "${msg}"
    return
}

__reportErr () {
    local msg
    msg="${*:-NULL}"
    if [[ "${msg}" != 'NULL' ]]; then
        msg="${ERROR_CLR}ERROR:${CLR_RST}\\n${msg:?}"
        __printHeading "${msg}" >&2
    else
        return 1
    fi
    return
}

__setBashEnvVariables

if [[ -z "${bashenv:-}" ]]; then
    declare -xr bashenv="$(__getBashEnvDir)"
fi

[[ -L ~/.bashrc && -r ~/.bashrc ]] && . ~/.bashrc

if [[ -n "${bashenv_debug_verbosity:-}" ]]; then
    unset bashenv_debug_verbosity
fi
