#!/usr/bin/env bash
# bash_shell_check

bash_shell_check ()
{
    [[ -z "${bashenv:-}" ]] && return 1
    
    _list_all_bashenv_files ()
    {
        find "${bashenv:?}" -mindepth 1 -type f \
            \! \( -path "*/.git/*" -or -name ".*" -or -name "_*" \)
        return
    }

    while read -r srcpath; do
        local output
        output="\\n\\tSHELLCHECK > "
        output+="$(basename "$0")\\n\\n"
        shellcheck -x -e1090 "${srcpath:?}"

    done < <(_list_all_bashenv_files)
    return
}
