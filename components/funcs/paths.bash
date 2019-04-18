#!/usr/bin/env bash
# paths

paths ()
{
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
