#!/usr/bin/env bash
# update

update () {
    
    local -a updateSessions
    updateSessions=(
        brew
        "brew cask"
        gem
        softwareupdate
    )

    for updateSession in "${updateSessions[@]}"; do
        if [[ "${updateSession}" == "${updateSessions[0]}" ]]; then
            hr -l
        else
            hr
        fi
        echo ">>> ${updateSession}"
        case "${updateSession}" in
            brew)
                for TYPE in update upgrade; do
                    echo ">>>> ${updateSession} ${TYPE}"
                    brew "${TYPE}"
                done
                ;;
            brew\ cask)
                echo ">>>> ${updateSession}"
                    brew cask upgrade
                ;;
            gem)
                sudo gem update
                ;;
            softwareupdate)
                osUpdatesAvail="$(softwareupdate --list --all > /dev/null 2>&1)"
                if [[ -z "${osUpdatesAvail:-}" ]]; then
                    echo -e "\\n\\t<NONE>"
                else
                    echo -e "\\n\\tOS UPDATES AVAILABLE..."
                    echo "${osUpdatesAvail}" | sed 's:^:	:'
                fi
                ;;
        esac
    done

    #
    #-:TRAILING HR
    hr -t
    return
}
