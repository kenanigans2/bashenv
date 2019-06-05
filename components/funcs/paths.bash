#!/usr/bin/env bash
# paths

paths ()
{
    #shellcheck disable=1004
    echo -e "${PATH//:/\\n}" \
        | nl \
        | sed -e "1i\\
        \\
        \\  PATH=${PATH:-}\\
        \\
        " -e '$a\
        \
        '
    return
}
