#!/usr/bin/env bash
# bashrc.d/locationVars.bash

___reportFuncNames () {
    echo "FUNCNAMES (${#FUNCNAME[@]}):"
    for fn in "${!FUNCNAME[@]}"; do
        echo -e "\\t- ${fn}"
        echo -e "\\t[${fn}]=\"${FUNCNAME[${fn}]}\""
    done
    echo
    return
}

____handleErrs () {
    if (( ${#errorNames[@]} < 1 )); then
        return 0
    else
        {
            hr
            __printHeading "ERROR: ${#errorNames[@]}errors occurred when attempting to set location variables..."
            for name in "${errorNames[@]}"; do
                echo -e "\\t[${name%%:*}] => ${2##*:}"
            done
        } \
            >&2
        hr -t
    fi
    return
}

__verifyLocationVars() {


    echo ">> VERIFYING LOCATION (${*})"\!
    #
    # $1: name
    # $2: path
    if [[ -n "${!1}" ]]; then
        [[ "${!1}" == "${2:?}" ]] \
            && continue \
            || eval 'unset '"${1}"
    fi
    #
    #-:name value ($1) must be null, and directory must exist to continue
    if [[ -z "${!1:-}" && -d "${2:?}" ]]; then
        cmd="export ${1:?}=${2:?}"
        echo -e "\\tsetting var: ${1:?} -- \`${cmd}\`"
        echo -e "\\tCOMMAND: ${cmd}"
        eval "${cmd}"
        echo -en "\\t"
        [[ -n "${!1:?}" ]] \
            && echo "SUCCESS (${cmd})" \
            || echo "FAILED: ${cmd}" >&2
        if [[ -n "${!1:-}" && -d "${!1:-}" ]]; then
            successfulNames+=(${1:?})
        else
            echo "ERROR (45)" >&2
            ___reportFuncNames
            errorNames+=("${1:?}:${2:?}")
        fi
    else
        echo "ERROR (51):" >&2
        ___reportFuncNames
        errorNames+=( "${1:?}:${2:?}" )
    fi
    return
}

if [[ "$(declare -F hr 2> /dev/null)" != 'hr' ]]; then
    if [[ -r "${bashenv}/bashrc.d/function_modules/hr.bash" ]]; then . "${bashenv}/bashrc.d/function_modules/hr.bash"
    else echo "ERROR: unable to find dependencies -- ${bashenv}/bashrc.d/function_modules/hr.bash" >&2 && return 10
    fi
fi

declare -a loadedLocationVars successfulNames errorNames
successfulNames=() errorNames=()
loadedLocationVars=()
declare -A places
places=(
    [dev]=~/Developer
    [desk]=~/Desktop
    [sites]=~/Sitess
)

for locationVarName in "${!places[@]}"; do
    #echo "${locationVarName}" "${places[${locationVarName}]}"
    __verifyLocationVars "${locationVarName}" "${places["${locationVarName}"]}"
    continue
done

____handleErrs

unset places
unset -f __verifyLocationVars

