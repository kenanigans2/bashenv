#!/usr/bin/env bash
# gensh

reportErr ()
{
    local -r ERRCOLOR=$'\033[41;37;1m'
    local -r RSTCOLOR=$'\033[0;0m'
    listFuncNames ()
    {
        echo "ENTERING FUNCTION: caseOpts"
        if ((${#FUNCNAME[@]}>1)); then
            echo "FUNCNAMES (${#FUNCNAME[@]}):"
            for f in "${!FUNCNAME[@]}"; do
                echo -e "\\t${f}. ${FUNCNAME[${f}]}"
            done
            echo
        fi
        return
    }

    caseOpts ()
    {
        
        echo "$@"
    }


    local msg="ERROR"
    case "${1:-}" in
        invalidFlag)
            shift 1
            msg+=": invalid flag - ${1}"
            ;;
        *)
            msg="ERROR"\!
            ;;
    esac
    msg="${ERRCOLOR} ${msg} ${RSTCOLOR}"
    echo -e "${msg}"
    return
}

createNewBashFile ()
{
    _reportFunction ()
    {
        echo "CREATE NEW BASH FILE..."
        echo "DETAILS:"
        for x in "$@"; do
            echo -e "\\t- ${x}"
        done
        echo
        return
    }

    #
    # SET GLOBAL VARS:
    # - FILENAME
    # - FILEEXTENSION
    # - FILEDIRNAME
    # - FILEFULLPATH
    #
    {
        if [[ "${1##*.}" == 'bash' ]]; then
            FILENAME="${1%.*}"
            FILEEXTENSION="${1##*.}"
        echo 111
        elif
            ! echo "${1:?}" | grep -Eq "\."
        then
            FILENAME="${1:?}.sh"
            FILEEXTENSION='sh'
        echo 222
        else
            echo "ERROR" >&2
        echo 333
            exit 2
        fi
        
    }
    return
}

createNewScriptFile ()
{
    case "${1:?}" in
        bash)
            shift 1
            createNewBashFile "$@"
            ;;
    esac
    return
}

#
# DECLARE GLOBAL VARS
#
{
    declare FILENAME= FILEEXTENSION= FILEDIRNAME= FILEFULLPATH=
}

if [[ $# -gt 0 && "${1:0:1}" == '-' ]]; then
    #
    # PARAMETERS WERE PASSED
    # - parse passed parameters
    #
    {
        while getopts :bypsja opt; do
            case ${opt} in
                b)
                    #
                    # BASH FILE SPECIFIED
                    #
                    shift 1
                    createNewScriptFile 'bash' "$@"
                    ;;
                a)
                    echo "APPLESCRIPT FILE SPECIFIED"
                    for ((c=0;c<$#;c++)); do shift 1; done
                    ;;
                j)
                    echo "JAVASCRIPT FILE SPECIFIED"
                    for ((c=0;c<$#;c++)); do shift 1; done
                    ;;
                s)
                    echo "SWIFT FILE SPECIFIED"
                    for ((c=0;c<$#;c++)); do shift 1; done
                    ;;
                p)
                    echo "PHP FILE SPECIFIED"
                    for ((c=0;c<$#;c++)); do shift 1; done
                    ;;
                y)
                    echo "PYTHON FILE SPECIFIED"
                    for ((c=0;c<$#;c++)); do shift 1; done
                    ;;
                ?)
                    reportErr "invalidFlag" "${OPTARG}"
                    exit 1
                    ;;
            esac
        done
    }

    (( $# == 0 )) && exit


    echo "BASHENV: ${bashenv}"
    echo "SCRIPT DIR: ${scripts}"
    echo "FILENAME: ${FILENAME}"
    echo "EXTENSION: ${FILEEXTENSION}"
#    echo "FILE DETAILS (${#}):"
#    for x in "${@}"; do
#        echo -e "\\t- ${x}"
#    done
    echo

fi


