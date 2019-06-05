#!/usr/bin/env bash
# general bin config

#
#-:COLORIZE COMMANDS
{
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'

    command -v tree &> /dev/null \
        && alias tree='tree -C'

    if [[ "$(uname)" == 'Darwin' ]]; then
        alias ls='/bin/ls -G'
    elif [[ "$(uname)" == 'Linix' ]]; then
        alias ls='/bin/ls --color=auto'
    fi
}

#
#-:`ls' ALIASES
{
    alias la='ls -A'
    alias ll='ls -l'
    alias lla='ls -lA'
    alias l1='ls -1'
    alias lm='ls -m'
    alias l.='ls -d .[^$.]* 2> /dev/null || echo "<no dot files>"'
    alias ll.='ls -dl .[^$.]* 2> /dev/null || echo "<no dot files>"'
    alias lll='ls -dlL .[^$.]* 2> /dev/null || echo "<no dot files>"'
    alias l1.='ls -d1 .[^$.]* 2> /dev/null || echo "<no dot files>"'
    alias lm.='ls -dm .[^$.]* 2> /dev/null || echo "<no dot files>"'
}
