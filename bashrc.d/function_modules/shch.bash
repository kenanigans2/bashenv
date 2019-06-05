#!/usr/bin/env bash
# shch

if command -v shellcheck > /dev/null; then
    shch () {
        ___shch_listAllBashEnvFiles () {
            find $bashenv -type f \! \( -path "*/.git/*" -or -name "*.swp" \)
        }

        shellcheck -x $(___shch_listAllBashEnvFiles)
        return
    }
fi
