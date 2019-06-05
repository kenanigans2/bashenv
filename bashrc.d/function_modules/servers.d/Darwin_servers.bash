#!/usr/bin/env bash
# Darwin servers

__printHeading "==SERVERS=="
{
    __printHeading "APACHE: $(
    if (( $(pgrep httpd | wc -l | tr -dc '0-9') > 0 )); then
        echo -e "[32;1mONLINE[0;0m"
    else
        echo -e "[31;1mOFFLINE[0;0m"
    fi
    )"

    __printHeading "MYSQL: $(
    if [[ "$(brew services list | grep maria | cut -d' ' -f2)" == 'started' ]]; then
        echo -e "[32;1mONLINE[0;0m"
    else
        echo -e "[31;1mOFFLINE[0;0m"
    fi
    )"
} \
    | grep -v "^[[:blank:]]*$" \
    | sed '$a\
    \
    '
