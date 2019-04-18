#!/usr/bin/env bash
# funcs

funcs ()
{
    [[ "${funcnames[*]:-NULL}" == 'NULL' ]] \
        && echo "ERROR: no functions loaded" >&2 \
        && return 1

    [[ "${funcs:-NULL}" == 'NULL'  || ! -d "${funcs:?}" ]] \
        && echo "ERROR: function directory not declared..." >&2 \
        && return 1

    __list_func_dir ()
    {
        find "${funcs}" -mindepth 1 -maxdepth 1 -type f \
            \! \( -name ".*" -or -name "*.swp" \) \
            2> /dev/null \
            || return 1
        return 0
    }

    __list_func_dir_basenames ()
    {
        while read -r LINE; do
            bn1="$(basename "${LINE}")"
            bn2="${bn1%\.*}"
            echo "${bn2}"
        done \
            < <(__list_func_dir)
        return
    }

    __delete_existing_file ()
    {
        if [[ -f "$(echo "${funcs:?}/${OPTARG}"*)" ]]; then
            targetToDelete=$(echo "${funcs}/${OPTARG}"*)
            local -l REPLY
            REPLY=
            read -rp "OKAY TO DELETE -- ${targetToDelete}? (y/N) " REPLY
            case "${REPLY:0:1}" in
                y)
                    rm "${targetToDelete}"
                    [[ ! -f "${targetToDelete}" ]] \
                        && echo "SUCCESS"\! \
                        || echo "ERROR: failed to delete specified file -- ${targetToDelete}" >&2
                    ;;
                *)
                    echo "ERROR: failed to delete specified file -- ${targetToDelete}" >&2
                    ;;
            esac
        else
            file "${funcs}/${OPTARG}"*
        fi
        return
    }

    __edit_existing_file ()
    {
        targetFile="${OPTARG}"
        funcname="$(echo "${targetFile}" | sed -e 's:^.*/::' -e 's:\.bash$::')"
        [[ "${targetFile##*.}" != 'bash' ]] \
            && targetFile+=".bash"
        targetFilePath="${funcs:?}/${targetFile}"
        if [[ -r "${targetFilePath}" ]]; then
            echo "EDITING FILE... ${targetFile}"
            ${EDITOR:-vim} "${targetFilePath}"
        fi

        return
    }

    __create_new_func_file ()
    {
        echo "ADDING NEW: ${OPTARG}"

        targetFile="${OPTARG}"
        funcname="$(echo "${targetFile}" | sed -e 's:^.*/::' -e 's:\.bash$::')"

        if [[ "${targetFile##*.}" != 'bash' ]]; then
            targetFile="${targetFile##*/}.bash"
        fi

        targetFilePath="${funcs:?}/${targetFile}"

        if [[ ! -f "${targetFilePath}" \
            && ! -d "${targetFilePath}" \
            && ! -L "${targetFilePath}" \
            ]]; then
            echo "CREATING FILE... ${targetFilePath}"
            ## PROCEED TO CREATE FILE
            touch "${targetFilePath}"
            cat <<EOF >> "${targetFilePath}"
#!/usr/bin/env bash
# ${funcname}

${funcname} ()
{
    echo
    return
}
EOF
        fi
        return
    }

    if [[ ${#} -le 0 ]]; then
        #
        # DEFAULT ACTION
        __list_func_dir
    else

        local -i OPTIND
        local funcname targetFile targetFilePath
        targetFile=''
        OPTIND=1
        while getopts :l1e:n:d: opt; do
            case ${opt} in
                d)
                    ## DELETE EXISTING
                    __delete_existing_file
                    ;;
                e)
                    ## EDIT EXISTING
                    __edit_existing_file
                    ;;
                n)
                    ## NEW
                    __create_new_func_file
                    ;;
                1)
                    __list_func_dir_basenames
                    return
                    ;;
                l)
                    __list_func_dir
                    return
                    ;;
                ?)
                    echo "ERROR: invalid flag -- ${OPTARG}" >&2
                    return 1
                    ;;
            esac
        done

        shift $((OPTIND-1))
    fi
	return

}

