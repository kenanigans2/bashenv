#!/usr/bin/env bash
# bashrc

#echo BASHRC SOURCED

if [[ -d ~/.bashrc.d ]]; then
    #
    #-: LOCATION VARS
    {
        [[ -r ~/.bashrc.d/locationVars.bash ]] \
            && . ~/.bashrc.d/locationVars.bash
    }
    #
    #-:LOAD SYSTEM-SPECIFIC CONFIG
    #shellcheck disable=1004
    {
      if [ -r ~/.bashrc.d/sys/"$(uname)".bash ]; then
          #shellcheck disable=1090
          . ~/.bashrc.d/sys/"$(uname)".bash
      fi
      #
      #-:LOAD TERM_PROGRAM SPECIFIC CONFIG
      if [ -r ~/.bashrc.d/terms/"$(uname).${TERM_PROGRAM:-}.bash" ]; then
          #shellcheck disable=1090
            #shellcheck disable=2154
          if (( bashenv_debug_verbosity == 0 )); then
            . ~/.bashrc.d/terms/"$(uname).${TERM_PROGRAM:-}.bash"
          else
            . ~/.bashrc.d/terms/"$(uname).${TERM_PROGRAM:-}.bash" &> /dev/null
          fi
      fi
      #
      #-:LOAD BINARY-SPECIFIC CONFIG
      if [ -d ~/.bashrc.d/bin_config ]; then
          while read -r FILE; do
              #shellcheck disable=1090
              if (( bashenv_debug_verbosity == 0 )); then
                . "${FILE}"
              else
                . "${FILE}" &> /dev/null
              fi
          done < <(find ~/.bashrc.d/bin_config -mindepth 1 -type f \
              \! \( \
                  -name ".*" \
                  -or -name "*.swp" \
                  -or -name "_*" \
              \)
              )
      fi
      unset file
    } \
      | sed 's:^:	:' | sed -e '1i\
      \
      '
    #
    #-:LOAD BASH ALIASES & FUNCTIONS
    {
      declare file
      for ancillary in aliases functions; do
          file="${HOME}/.bashrc.d/${ancillary:-}.bash"
          if [[ -n "${file:-}" && -f "${file}" && -r "${file}" ]]; then
              #shellcheck disable=1090
              . "${file}" 
          else
              __reportErr "Unable to source init file: ${file}"
          fi
      done
    }
fi
