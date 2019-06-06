#!/usr/bin/env bash
# Apple_Terminal

[[ -n ${bashenv_debug_verbosity} ]] \
  && (( bashenv_debug_verbosity == 0 )) \
  && echo "TERM_PROGRAM: ${TERM_PROGRAM}"
