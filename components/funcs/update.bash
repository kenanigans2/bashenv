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
        && echo "UPDATING: GOOGLE-FONTS REPO" \
        && git fetch && git pull && git push && cd ~- \
        || echo "ERROR: error updating google-fonts git repo" >&2
    hr

    [[ -d ${bashenv} ]] \
        && cd ${bashenv} \
        && echo "UPDATING: BASHENV REPO" \
        && git fetch && git pull && git push && cd ~- \
        || echo "ERROR: error updating bashenv git repo" >&2
    hr

    echo
    return
}
