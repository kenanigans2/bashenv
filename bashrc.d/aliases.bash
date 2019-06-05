#!/usr/bin/env bash
# aliases.bash

#echo "FILE SOURCED: ${BASH_SOURCE[0]}"

alias x='exit'
alias c='clear'

#
#-:LOAD ALIAS MODS
if [[ -d ~/.bashrc.d/alias_modules ]]; then
    #
    #-:SET VARS
    {
        [[ -z "${aliasMods:-}" ]] && declare -x aliasMods=~/.bashrc.d/alias_modules
        [[ -n "${loadedAliasMods[*]}" ]] && unset loadedAliasMods
        declare -xa loadedAliasMods
        loadedAliasMods=()
    }
    #
    #-:SET ALIAS MOD FILE ARRAY
    mapfile loadedAliasMods < <(find ~/.bashrc.d/alias_modules -type f \! \
        \( -name ".*" -or -name "*.swp" -or -name "_*" \) \
        | grep -v '^[[:blank:]]*$')
    #
    #-:SOURCE EACH ALIAS MOD
    for a in "${loadedAliasMods[@]}"; do
        a="$(echo "$a" | tr -d '\n')"
        #shellcheck disable=1090
        . "${a}"
    done
fi
