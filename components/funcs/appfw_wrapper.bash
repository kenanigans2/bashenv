#!/usr/bin/env bash
# appfw_wrapper.bash

appfw ()
{
    if (( $# == 0 )); then
        app_firewall -h
    else
        app_firewall "$@"
    fi
    return
}
