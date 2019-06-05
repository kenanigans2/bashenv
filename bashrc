#!/usr/bin/env bash
# bashrc

#echo BASHRC SOURCED

if [[ -d ~/.bashrc.d ]]; then
    declare file
    for ancillary in aliases functions; do
        file="${HOME}/.bashrc.d/${ancillary:-}.bash"
        if [[ -n "${file:-}" && -f "${file}" && -r "${file}" ]]; then
            . "${file}"
        else
            _reportErr "Unable to source init file: ${file}"
        fi
    done
    unset file
fi
