#!/usr/bin/env sh
# profile

#
#-:SET VARS
{
    export MYNAME='Kenneth Dait'
    export CDPATH=.:~
    { command -v vim > /dev/null && export EDITOR=vimm; } \
        || { command -v vi > /dev/null && EDITOR=vim; }
    { command -v less > /dev/null && export PAGER=less; }
}
