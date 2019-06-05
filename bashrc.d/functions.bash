#!/usr/bin/env bash
# functions.bash

__findFunctionModuleFiles ()
{ find "${funcs}" -mindepth 1 -maxdepth 1 -type f -name "[^.]*.bash"; }

__reportLoadedFunctions ()
{
    __printHeading "FUNCS (${#loadedFuncs[@]}):"
    local f
    for f in "${loadedFuncs[@]}"; do
        echo -e "\\t- ${f}"
    done
    echo
    return
}

if [[ -d ~/.bashrc.d/function_modules ]]; then
    #
    #-:SET FUNCS VAR IF NOT YET SET
    [[ -z "${funcs:-}" ]] \
        && declare -rx funcs=~/.bashrc.d/function_modules
    #
    #-:[RE]SET `loadedFuncs' ARRAY TO EMPTY
    (( ${#loadedFuncs[@]} > 0 )) \
        && unset loadedFuncs \
        && declare -ax loadedFuncs=()
    #
    #-:LOAD FOUND FUNCTION MODULE FILES INTO ARRAY
    mapfile -d ':' loadedFuncs < <(__findFunctionModuleFiles | tr '\n' ':')
    #__reportLoadedFunctions
    #
    #-:IF ARRAY NOT EMPTY, ATTEMPT TO SOURCE EACH FILE
    if (( ${#loadedFuncs[@]} > 0 )); then
        (( ${bashenv_debug_verbosity:-1} == 0 )) \
            && __printParagraph -l "LOADING FUNCS..."
        for f in "${loadedFuncs[@]}"; do
            f="${f%:}"
            #shellcheck disable=1090,2015
            . "${f}" \
                && {
                    (( ${bashenv_debug_verbosity:-1} == 0 )) \
                        && eval "__printParagraph -i1 -b'-' \"$(\
                            basename "${f}" \
                                | sed 's:\.bash$::'\
                            )\"" \
                        || echo -n
                    } \
                || __reportErr "UNABLE TO SOURCE FUNC MODULE: ${f}"
        done
        unset f
    else
        __reportErr "No function module files found"
    fi
    
fi

