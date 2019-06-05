#!/usr/bin/env bash
# VirtualBox config

if command -v VirtualBox &> /dev/null; then
    
    vbox () {
        ___vbox_listAllVMs () { VBoxManage list vms | awk -F'"' '{print $2}'; }
        ___vbox_listRunningVMs () { VBoxManage list runningvms | awk -F'"' '{print $2}'; }
        ___vbox_setVars () {
            vmsAll=( $(___vbox_listAllVMs) )
            vmsRunning=( $(___vbox_listRunningVMs) )
        }
        ___vbox_printStatus () {
            __printHeading "ALL VMs:"
            (( ${#vmsAll[@]} > 0 )) \
                && __printParagraph -b "-" "$(echo "${vmsAll[@]}" | tr ' ' '\n')" \
                || __printParagraph -b "-" "<NONE>"
            __printHeading "RUNNING VMs:"
            (( ${#vmsRunning[@]} > 0 )) \
                && __printParagraph -b "-" "$(echo "${vmsRunning[@]}" | tr ' ' '\n')" \
                || __printParagraph -b "-" "<NONE>"
            echo
        }

        declare -ax vmsRunning vmsAll
        ___vbox_setVars
        if (($#==0)); then
            ___vbox_setVars
            ___vbox_printStatus
        else
            local -i OPTIND
            while getopts :ra opt; do
                case ${opt} in
                    r) ___vbox_listRunningVMs;;
                    a) ___vbox_listAllVMs;;
                    \?)
                        __printErr "invalid flag -- ${OPTARG}"
                        ;;
                esac
            done
            shift $((OPTIND-1))
            return
        fi

        return
    }
fi
