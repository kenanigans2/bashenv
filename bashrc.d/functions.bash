#!/usr/bin/env bash
# functions.bash

#echo "FILE SOURCED: ${BASH_SOURCE[0]}"

__findFunctionModuleFiles ()
{
    find "${funcs:?}" \
        -mindepth 1 -maxdepth 1 \
        -type f \
        \! \( \
            -name "*.swp" \
            -or -name "_*" \
            -or -name ".*" \
        \)
    return
}

__reportLoadedFunctions ()
{
    __printHeading "FUNCS (${#loadedFuncs[@]}):"
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
    mapfile loadedFuncs < <(__findFunctionModuleFiles)
    #__reportLoadedFunctions

    if (( ${#loadedFuncs[@]} > 0 )); then
        for f in "${loadedFuncs[@]}"; do
            . ${f}
        done
    fi
    
fi
