#!/usr/bin/env bash
# sbash

sbash () {
    #
    #-:DEBUG FLAG `-d' INCREASES VERBOSITY WHILE SOURCING INIT FILES
    local -i DEBUG; DEBUG=0
    while getopts :d opt; do
        case ${opt} in
            d) DEBUG=1;;
            \?) break;;
        esac
    done
    declare -i bashenv_debug_verbosity
    bashenv_debug_verbosity=1   # 1=silent; 0=verbose
    if [[ -f ~/.bash_profile && -r ~/.bash_profile ]]; then
        #
        #-:SET `bashenv_debug_verbosity' TO 0 IF VERBOSE SPECIFIED
        #shellcheck disable=2034
        ((DEBUG==1)) && bashenv_debug_verbosity=0
        #
        #-:SOURCE FILE
        #shellcheck source=/Users/kend/.bash_profile
        . ~/.bash_profile
    else
        __reportErr "unable to find user bash_profile -- ~/.bash_profile"
        return 1
    fi
    return
}

