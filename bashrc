#!/usr/bin/env bash
# bashrc

#echo BASHRC SOURCED

if [[ -d ~/.bashrc.d ]]; then
    declare file
    for ancillary in aliases functions; do
        file="${HOME}/.bashrc.d/${ancillary:-}.bash"
        if [[ -n "${file:-}" && -f "${file}" && -r "${file}" ]]; then
            #shellcheck disable=1090
            . "${file}" 
        else
            __reportErr "Unable to source init file: ${file}"
        fi
    done
echo
    #
    #-:LOAD TERM_PROGRAM SPECIFIC CONFIG
    if [ -r ~/.bashrc.d/terms/"$(uname).${TERM_PROGRAM:-}" ]; then
        #shellcheck disable=1090
        . ~/.bashrc.d/terms/"$(uname).${TERM_PROGRAM:-}"
    fi

    unset file
fi
