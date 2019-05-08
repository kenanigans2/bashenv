#!/usr/bin/env bash
#

netinfo ()
{
    ifconfig en0 inet \
        | sed 's:^[[:blank:]]*::' \
        | tr '\n' ';' \
        | sed \
            -e 's:;$::' \
            -e 's:;:; :' \
            -e 's:flags[^>]*> \(mtu[^;]*\);:\1;:' \
        | sed -E \
            -e 's:([0-9]) ([^ ]):\1; \2:g' \
            -e 's:([0-9]{1}[0-9a-fx.]+):[34;1m\1[0;0m:g'
    return
}
