#!/usr/bin/env bash
# function: names

if [[ "$(uname -s)" == 'Darwin' ]]; then
    names ()
    {
        __list_out_computer_names ()
        {
            names=(
                ['LocalHostName']='' ['HostName']='' ['ComputerName']=''
            )

            for key in "${!names[@]}";do
                names[$key]="$(scutil --get "${key}" 2> /dev/null)"
                if [[ -z "${names[$key]}" ]]; then
                    names[$key]="< NOT SET >"
                fi
            done

            # shellcheck disable=1004
            for key in "${!names[@]}"; do
                echo -e "${key}: ${names[$key]}"
            done | awk -F": " '{printf ("%*s\t%s\n"),-20,$1,$2}' \
                | sed -E -e '1i\
                    \
                    \	COMPUTER NAMES:\
                    \
                    ' -e '$a\
                    \
                    ' -e 's:^:	:'

            return
        }

        local -A names=()

        if (($#==0)); then
            __list_out_computer_names
        fi
        return
    }
fi
