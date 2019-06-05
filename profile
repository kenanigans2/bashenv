#!/usr/bin/env sh
# profile

shopt -s cdable_vars extglob globstar

#
#-:SET VARS
{
    export MYNAME='Kenneth Dait'
    export CDPATH=.:~
    { which vimm &> /dev/null && export EDITOR=vimm; } \
        || { which vi &> /dev/null && EDITOR=vim; }
    { which less &> /dev/null && export PAGER=less; }
}
