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
    unset file
fi
