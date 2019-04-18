#!/usr/bin/env bash
# lavg

lavg ()
{
    echo "$(uptime | awk -F": " '{print $NF}' | sed 's: :,&:g'), $(system_profiler SPHardwareDataType | grep 'Total Number of Cores' | awk -F": " '{print $NF}')"
    return
}
