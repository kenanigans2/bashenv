#!/usr/bin/env bash
#

target="${*}"

if [[ "${target:0:1}" == '/' ]]; then
    exit 0
else
    exit 1
fi


