#!/usr/bin/env bash
# functions.bash

#echo "FILE SOURCED: ${BASH_SOURCE[0]}"

hello ()
{
    echo "HELLO ${1:-WORLD}" \!
    return
}
