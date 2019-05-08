#!/usr/bin/env bash
# ps1

ps1 ()
{
    [[ -z "${ORIGINAL_PS1:-}" ]] \
        && declare -xr ORIGINAL_PS1="${PS1:?}"
    [[ "${ORIGINAL_PS1:?}" == "${PS1:?}" ]] \
        || {
            echo "${FUNCNAME[0]}: error." >&2
            return 1
        }

    local MINIMAL_PS1='\$ '

    echo "PS1 FUNC"

    if [[ "${PS1:?}" == "${ORIGINAL_PS1:?}" ]]; then
        # switch to minimal
        echo "SWITCH TO MINIMAL"
        export PS1="${MINIMAL_PS1:?}"
    else
        echo "SWITCH TO ORIGINAL"
        export PS1="${ORIGINAL_PS1:?}"
    fi
    echo DONE
    return
}
