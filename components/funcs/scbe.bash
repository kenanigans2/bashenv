#!/usr/bin/env bash
# scbashenv

scbe ()
{
    _PRINT_EVERYTHING ()
    {
        _listBashEnvFiles ()
        {
            find $bashenv/{components,scripts} \
                -type f \! -empty \
                \! \( \
                    -name ".*" \
                    -or -name "*.php" \
                    -or -name "*.swp" \
                    -or -name "_*" \
                \)
            return
        }

        _reportCounts ()
        {
            echo "SCBASHENV_BAD (${#SCBASHENV_BAD[@]}):"
            for ((c=0;c<${#SCBASHENV_BAD[@]};c++)); do
                echo -e "\\t- ${SCBASHENV_BAD[${c}]}"
            done
            hr
            echo "SCBASHENV_GOOD (${#SCBASHENV_GOOD[@]}):"
            for ((c=0;c<${#SCBASHENV_GOOD[@]};c++)); do
                echo -e "\\t- ${SCBASHENV_GOOD[${c}]}"
            done
            hr
            echo
            return
        }

        unset SCBASHENV_GOOD SCBASHENV_BAD
        local -a SCBASHENV_GOOD=() SCBASHENV_BAD=()
        while read -r FILEPATH; do

            output="$(shellcheck -x "${FILEPATH}" 2>&1)"
            hr
            if [[ -z "${output:-}" ]]; then
                SCBASHENV_GOOD+=( "$(basename "${FILEPATH}")" )
                echo -e "[42;30;1m$(basename "${FILEPATH}"):\\nALL SCBASHENV_GOOD"\!"[0;0m"
            else
                SCBASHENV_BAD+=( "$(basename "${FILEPATH}")" )
                echo -e "[41;37;1mFAILED - ${FILEPATH}" \
                    && \
                        echo -e "${output}" \
                            | sed 's:^:	:'
                echo -e "[0;0m"
            fi
        done < <(_listBashEnvFiles)

        _reportCounts
        return
    }

    _PRINT_EVERYTHING
}

#scbashenv ()
#{
#    getAllBashEnvFiles ()
#    {
#        local targetDir="${bashenv:?}/components/"
#        find "${targetDir}" -type f -exec basename "{}" \; 2> /dev/null
#        return
#    }
#
#    for f in $(); do
#        #shellcheck disable=2154
#        SHORTNAME="${f%.*}" FILEPATH="${funcs}/${f}"
#        TMPFILE="$(mktemp -tmp "${SHORTNAME}")"
#
#        {
#            shellcheck -x "${FILEPATH}"
#        } \
#            &> "${TMPFILE}"
#
#        hr && echo -e "\\n\\tFUNCTION FILE: ${SHORTNAME}\\n\\n"
#
#        if [[ ! -s "${TMPFILE}" ]]; then
#            #shellcheck disable=2140
#            echo -e "\\n\\t ALL SCBASHENV_GOOD"\!" \\n"
#        else
#            cat "${TMPFILE}"
#        fi
#
#        echo
#
#        rm "${TMPFILE}" \
#            || echo "ERROR: FAILED TO RM TMPFILE -- ${TMPFILE}" >&2
#
#    done
#    return
#}
#
#alias scbe="scbashenv"
