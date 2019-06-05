#!/usr/bin/env sh
# profile

#
#-:SET VARS
{
    export MYNAME='Kenneth Dait'
    export CDPATH=.:~
    { command -v vim && export EDITOR=vimm; } \
        || { command -v vi && EDITOR=vim; }
    { command -v less && export PAGER=less; }
}
