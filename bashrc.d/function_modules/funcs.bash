#!/usr/bin/env bash
# funcs

funcs () {
  #
  #-:Access and modify bashenv function module files
  #
  #   - `functions.bash` finds every file in the `function_modules` folder
  #+      ending in `.bash`, and sources it. This is meant to deal with
  #+      each function separately
  #       - source file: `${HOME}/bashrc.d/functions.bash`
  #       - module directory: `${HOME}/bashrc.d/function_modules`
  #           - `bashenv` stores this directory as variable **`$funcs``**
  #
  #   - FLAG OPTIONS
  #       -n "[name (req)]" "[description]"
  #           - create new function file
  #           - accepts no other flags
  #           - $1 (required): name of function
  #               - `.bash` extension is detected, so it isn't added twice,
  #+                  but it's not necessary to append
  #               - 

  #
  main () {
    #
    #-:MAIN THREAD OF EXECUTION
    #
    local FUNCOPTS
    FUNCOPTS='auglned'
    if (($#==0)); then
      #
      #-:NO ARGS, DEFAULT ACTION IS TO MOVE TO FUNCTION MODULE DIRECTORY
      #
      __moveToFunctionModuleDir
    else
      local -i OPTIND
      OPTIND=1
      while getopts :"${FUNCOPTS}" opt; do
        case ${opt} in
          n)
            # make new file
            ___make_new_function_module
            ;;
          e)
            ___edit_function_module
            ;;
          d)
            ___delete_function_module
            ;;
          l)
            ___list_all_func_names
            #__list_function_modules
            ;;
          a)
            __print_all_funcs
            ;;
          g)
            __moveToFunctionModuleDir
            ;;
          u)
            __print_user_funcs
            ;;
          \?)
            __printErr "invalid flag -- ${OPTARG}"
            ;;
        esac
      done
      shift $((OPTIND-1))
      return
    fi
    return
  }

  ___make_new_function_module () {
    echo "MAKE NEW FUNCTION MODULE"
  }

  ___edit_function_module () {
    echo "EDIT EXISTING FUNCTION MODULE"
  }

  ___delete_function_module () {
    echo "DELETE EXISTING FUNCTION MODULE"
  }

  ___list_all_func_names () { declare -F | cut -c12-; }
  ___list_user_func_names () { ___list_all_func_names | grep -v '^_'; }
  __print_user_funcs () {
    __printHeading "USER FUNCTIONS:"
    __printParagraph -b"-" \
      -t "$(___list_user_func_names \
        | grep -v \
          -e "^shell_session_" \
          -e "^update_terminal_cwd"
      )"
  }
  __print_all_funcs () {
    __printHeading "ALL FUNCTIONS:" \
      && __printParagraph \
        -b"-" \
        -t "$(___list_all_func_names)"
  }
  __moveToFunctionModuleDir () {
  [[ -n "${funcs:-}" && -d "${funcs:?}" ]] \
    && cd "${funcs}" \
    && hr -l \
    && tree --noreport ${PWD} \
      | sed -e '1s:.*:[47;31;1m BASHENV FUNCTION MODULES\: [0;0m:' -e '1i\
      \
      ' -e '$a\
      \
      ' \
      | sed 's:^:	:' \
    && hr -t \
    && {
          #echo -e "[47;31;1m GIT STATUS: [0;0m" \
          __printHeading "[47;31;1m GIT STATUS: [0;0m" \
              && git status . \
                  | sed -e '$a\
                  \
                  '
      } \
          | sed -E '/^[[:blank:]]+\(.+\)[[:blank:]]*$/d' \
          | while read -r LINE; do
              if
                  #echo "${LINE}" | grep -q "[[:alpha:]]+:[[:blank:]]+[[:alnum:][:punct:]]+[[:blank:]]*$"
                  echo "${LINE}" \
                    | grep -Eq ":[[:blank:]]+[^$]" &> /dev/null
              then
                  # COLORIZE
                  LINE='[36;1m '"${LINE}"' [0;0m'
              fi \
                && echo -e "${LINE}" \
                  | sed 's:^:	:'
          done \
      && hr -t
  }
  main "$@"
  unset -f main
  return
}

