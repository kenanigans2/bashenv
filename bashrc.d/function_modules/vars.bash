#!/usr/bin/env bash
# vars

vars ()
{
    ___vars_print_raw_vars () { declare | sed -n '/^_=/,/^{/p' | sed -e '1d' -e '$d' | sed '$d'; }
    ___vars_print_names_only () { ___vars_print_raw_vars | awk -F"=" '{print $1}'; }
    ___vars_select_on_mac () {
        if (( "${1:-}" == '--' )) && [[ "$(uname -s)" == 'Darwin' \
            && "${TERM_PROGRAM:-}" == 'Apple_Terminal' ]]; then
            osascript -e "tell app \"System Events\" to keystroke \"a\" using {command down, shift down}"
        fi
    }
    ___vars_selectOnReturn () { (( ${#FUNCNAME[@]} == 1 )) && ___vars_select_on_mac; }

    ___vars_printFormatted () {
        case "${1:?}" in
            raw)
                __printHeading "VARIABLES:"
                __printParagraph -b"-" "$(___vars_print_raw_vars)"
                ;;
            names)
                __printHeading "VARIABLE NAMES:"
                __printParagraph -b"-" "$(___vars_print_names_only)"
                ;;
        esac
        echo
    }

    trap '___vars_selectOnReturn' RETURN
    local -i OPTIND
    OPTIND=1
    while getopts :nrpf opt; do
        case $opt in
            f|p)
                #
                #-:PRINT FORMATTED
                ___vars_printFormatted "raw"
                return
                ;;
            n)
                #
                #-:PRINT NAMES ONLY
                ___vars_printFormatted "names"
                return
                ;;
            r)
                ___vars_print_raw_vars
                return
                ;;
            \?)
                __reportErr "invalid flag -- ${OPTARG}" >&2
                ;;
        esac
    done \
        && shift $((OPTIND-1))

    ___vars_printFormatted "raw"
    return
}
