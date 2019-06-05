#!/usr/bin/env bash
# funcs

funcs () {
    ___list_all_func_names () {
        declare -F | cut -c12-
    }

    ___list_user_func_names () {
        ___list_all_func_names \
            | grep -v '^_'
    }

    __print_user_funcs () {
        __printHeading "USER FUNCTIONS:"
        __printParagraph -b"-" -t "$(___list_user_func_names | grep -v -e "^shell_session_" -e "^update_terminal_cwd")"
    }

    __print_all_funcs () {
        __printHeading "ALL FUNCTIONS:"
        __printParagraph -b"-" -t "$(___list_all_func_names)"
    }

    if (($#==0)); then
        __print_user_funcs
    else
        local -i OPTIND
        OPTIND=1
        while getopts :au opt; do
            case ${opt} in
                a)
                    __print_all_funcs
                    ;;
                u)
                    __print_user_funcs
                    ;;
                \?)
                    __printErr "invalid flag -- ${OPTARG}"
                    ;;
            esac
        done
    fi
    return
}
