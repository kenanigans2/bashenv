#!/usr/bin/env bash
# bash_profile

#echo BASH_PROFILE SOURCED

if [[ -z "${bashenv:-}" ]]; then
    declare -xr bashenv="$(__getBashEnvDir)"
fi

declare -r ERROR_CLR='[31;1m'
declare -r CLR_RST='[0;0m'

__getBashEnvDir ()
{
    dirname "$(find "${BASH_SOURCE[0]}" -exec /bin/ls -l {} \; | awk -F" -> " '{print $NF}')"
    return
}

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
