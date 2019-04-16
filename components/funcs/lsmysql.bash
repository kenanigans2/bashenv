#!/usr/bin/env bash
# list_mysql_procs

if
    command -v "mysql"  &> /dev/null
then
    lsmysql ()
    {
        ps -p $(pgrep mysql) -o pid,command | sed -e '1d' | sed 's: :|:' | sed -e 's: --:|+--:g' | tr '|+' '\n\t' | sed -e '1i\
        \
        ' -e '$a\
        \
        ' | sed -e '/^[0-9]/s:^\([0-9][0-9]*\).*$:[[31;1m\1[0;0m]:' -e 's:^:        :'
        return
    }
fi
