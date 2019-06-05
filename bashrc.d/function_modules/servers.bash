#!/usr/bin/env bash
# servers

servers () {
    if [[ -r "${BASH_SOURCE[0]%.*}.d/$(uname)_servers.bash" ]]; then
        . "${BASH_SOURCE[0]%.*}.d/$(uname)_servers.bash"
    fi
}
