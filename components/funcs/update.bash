#!/usr/bin/env bash

update ()
{
    for UPDATE in "brew "{update,upgrade,doctor} "brew cask "{upgrade,doctor} "softwareupdate -la"; do
        hr
        echo "UPDATING: ${UPDATE}"
        eval "${UPDATE}"
        echo
    done
    hr

    [[ -d ~/Developer/google-fonts/.git ]] \
        && cd ~/Developer/google-fonts \
        && git fetch && git pull && cd ~- \
        || echo "ERROR: error updating google-fonts git repo" >&2

    echo
    return
}
