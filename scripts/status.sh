#/usr/bin/env bash
#status.sh

#
# SET UP FUNCTIONS
#
{
    [[ -r "${funcs:?}/trim.bash" ]] \
        && source "${funcs}/trim.bash" \
        || exit 1

    wifi ()
    {
        /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport "$@"
        return
    }

    getSSIDs ()
    {
        wifi -s | sed '1d' | trim | cut -d' ' -f1 \
            | sort | uniq
        return
    }

    getNetLocations ()
    {
        networksetup --listlocations
        return
    }

    reportData ()
    {
        echo -e "\\nLOCATIONS:"
        for location in "${locations[@]}"; do
            echo "- ${location}"
        done
        echo -e "\\nSSIDs:"
        for id in "${ssids[@]}"; do
            echo "- ${ssid}"
        done
        return
    }

    declare -a ssids=() locations=()
    ssids=( $(getSSIDs) )
    locations=( $(getNetLocations) )

    reportData ()
    {
        echo -e "\\nLOCATIONS:"
        for location in "${locations[@]}"; do
            echo "- ${location}"
        done
        echo -e "\\nSSIDs:"
        for id in "${ssids[@]}"; do
            echo "- ${ssid}"
        done
        return
    }
}

set -o errexit
set -u
declare -ra KNOWN_SSIDS_FILE=/Users/kend/Developer/data/knownSSIDs.data
declare -ra KNOWN_SSIDS=(
    $(cat 

