#!/usr/bin/env bash
# bash_profile

#echo BASH_PROFILE SOURCED

declare -r ERROR_CLR='[31;1m'
declare -r CLR_RST='[0;0m'

__printHeading ()
{
    echo -e "\\n${*:?}" \
        | sed 's:^:	:'
    echo
    return
}

_reportErr ()
{
    local msg
    msg="${*:-NULL}"
    if [[ "${msg}" != 'NULL' ]]; then
        msg="${ERROR_CLR}ERROR:${CLR_RST}\\n${msg:?}"
        __printHeading "${msg}"
    else
        return 1
    fi
    return
}


[[ -L ~/.bashrc && -r ~/.bashrc ]] && . ~/.bashrc
