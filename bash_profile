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

__reportErr () {
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

__setBashEnvVariables

if [[ -z "${bashenv:-}" ]]; then
    declare -xr bashenv="$(__getBashEnvDir)"
fi

[[ -L ~/.bashrc && -r ~/.bashrc ]] && . ~/.bashrc

