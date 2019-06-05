#!/usr/bin/env sh
# profile

shopt -s cdable_vars

#
#-:SET VARS
{
    export MYNAME='Kenneth Dait'
    { which vimm &> /dev/null && export EDITOR=vimm; } \
        || { which vi &> /dev/null && EDITOR=vim; }
    { which less &> /dev/null && export PAGER=less; }
}
