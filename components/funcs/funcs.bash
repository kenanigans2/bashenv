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
            cat <<-EOF >> "${targetFilePath}"
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

