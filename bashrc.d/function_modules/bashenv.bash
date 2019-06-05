#!/usr/bin/env bash
# bashenv

bashenv () {
    if (($#==0)); then
        #shellcheck disable=2154
        cd "${bashenv}" || return 1
        clear
        git status
        echo
        tree
    fi
    return
}
