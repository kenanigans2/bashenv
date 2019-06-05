#!/usr/bin/env bash

update ()
{
    main ()
    {
        update_homebrew_for_macos
        update_os_software
        update_google_fonts_repo
        update_bashenv_repo
        hr
        echo
        return
    }

    _HEADER ()
    {
        local HLCOLOR=$'[33;1m'
        local COLORRST=$'[0;0m'
        local prog="${*}"
        prog='\n\t'"--> UPDATING: ${HLCOLOR}${prog}${COLORRST}"'\n'

        {
            hr
            echo -e "${prog:?}"
        }

        return
    }

    local -r ORIGINAL_WORKING_DIR="${PWD}"
    trap '[[ "${PWD}" != "${ORIGINAL_WORKING_DIR}" ]] 
        && cd "${ORIGINAL_WORKING_DIR}"' RETURN HUP INT

    update_homebrew_for_macos ()
    {
        for UPDATE in "brew "{update,upgrade,doctor} ; do
            _HEADER "${UPDATE}"
        done
        for UPDATE in "brew cask "{upgrade,doctor}; do
            hr
            echo "UPDATING: ${UPDATE}"
            eval "${UPDATE}"
            echo
        done
        return
    }
    
    update_os_software ()
    {
        _HEADER "macOS SOFTWARE"
        softwareupdate -la
        return
    }

    update_google_fonts_repo ()
    {
        _HEADER "Google Fonts Git Repository"

        [[ -d ~/Developer/google-fonts/.git ]] \
            && cd ~/Developer/google-fonts \
            && echo "UPDATING: GOOGLE-FONTS REPO" \
            && git fetch && git pull && git push && cd ~- \
            || echo "ERROR: error updating google-fonts git repo" >&2
        return
    }

    update_bashenv_repo ()
    {
        _HEADER "BASHENV REPO"

        # shellcheck disable=2154
        [[ -d "${bashenv}" ]] \
            && cd "${bashenv}" \
            && git fetch && git pull && git push && cd ~- \
            || echo "ERROR: error updating bashenv git repo" >&2
        return
    }

    main "$@"
    return
}
