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
    #
    #-:LOAD SYSTEM-SPECIFIC CONFIG
    if [ -r ~/.bashrc.d/sys/"$(uname)".bash ]; then
        #shellcheck disable=1090
        . ~/.bashrc.d/sys/"$(uname)".bash
    fi
    #
    #-:LOAD TERM_PROGRAM SPECIFIC CONFIG
    if [ -r ~/.bashrc.d/terms/"$(uname).${TERM_PROGRAM:-}.bash" ]; then
        #shellcheck disable=1090
        . ~/.bashrc.d/terms/"$(uname).${TERM_PROGRAM:-}.bash"
    fi
    #
    #-:LOAD BINARY-SPECIFIC CONFIG
    if [ -d ~/.bashrc.d/bin_config ]; then
        while read -r FILE; do
            #echo ">>> ${FILE}"
            . "${FILE}"
        done < <(find ~/.bashrc.d/bin_config -mindepth 1 -type f \
            \! \( \
                -name ".*" \
                -or -name "*.swp" \
                -or -name "_*" \
            \)
            )
    fi
    unset file
fi
