#!/usr/bin/env bash
# sizes

declare -r target="${1:-${PWD}}"
declare duArgs=
[[ -d "${target}" ]] && duArgs+='d'
