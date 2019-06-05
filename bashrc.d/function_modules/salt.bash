#!/usr/bin/env bash
# salt

salt () {
    curl -s 'https://api.wordpress.org/secret-key/1.1/salt/' \
        | sed "s:^.*',[[:blank:]]*'\([^']*\)'.*$:\1:" \
        | tr -d '\n'
    return
}
