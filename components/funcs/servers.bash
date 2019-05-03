#!/usr/bin/env bash
# servers

servers ()
{
    echo -n "APACHE: "
    if (( \
        $(curl -Is localhost | sed -n '1s:^[^[:blank:]]* \([0-9][0-9]*\).*$:\1:p') == 200 \
        && $(pgrep httpd 2> /dev/null | wc -l | tr -dc '0-9') > 0 \
    )); then

        echo -e "\\033[32;1mONLINE\\033[0;0m"
    else
        echo -e "\\033[31;1mOFFLINE\\033[0;0m"
    fi
    
    echo -n "MYSQL: "
    
    if (( \
        $(pgrep mysql | wc -l | tr -dc '0-9') > 0 \
    )) \
        && [[ -e /tmp/mysql.sock ]]; then
        echo -e "\\033[32;1mONLINE\\033[0;0m"
    else
        echo -e "\\033[31;1mOFFLINE\\033[0;0m"
    fi

    return

}

