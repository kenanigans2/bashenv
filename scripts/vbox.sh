#!/usr/bin/env bash
# vbox
# - wrapper for virtualbox
#

main ()
{
    local -i OPTIND
    OPTIND=1
    while getopts :r opt; do
        case ${opt} in
            r)
                echo -e "\\n\\tRUNNING VMs:\\n"
                local -a runningVMs
                runningVMs=()
                VBoxManage list runningvms | tr -d '"{}' | tr ' ' ':'
                ;;
            ?)
                echo "ERROR: invalid flag -- ${OPTARG}" >&2
                ;;
        esac
    done

    shift $((OPTIND-1))

    return
}

_vm_report ()
{
    local -a allVMs
    allVMs=( $(VBoxManage list vms | tr -d '"{}' | tr ' ' ':') )

    echo -e "\\n\\tALL VMs:\\n"
    for vm in "${allVMs[@]}"; do
        echo -e "\\t- ${vm%%:*} (${vm##*:})"
    done
    return
}

## REQUIRE DEPENDENCIES
##
{
    declare -i ERRCOUNT
    ERRCOUNT=0
    for bin in VirtualBox VBox{Manage,Headless}; do
        if ! command -v "${bin}" &> /dev/null; then
            ((ERRCOUNT+=1))
        fi
    done

    if ((ERRCOUNT>0)); then
        echo "ERROR: dependencies were not met. Must have VirtualBox installed..." >&2
        exit 10
    fi
}

if (( $# == 0 )); then
    _vm_report
    exit $?
else
    main "$@"
    return $?
fi

