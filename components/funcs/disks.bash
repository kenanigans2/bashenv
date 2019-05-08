#!/usr/bin/env bash

disks ()
{
    hr
    echo -e "\\033[44;37;1m DISKS \\033[0;0m"
    diskutil list \
        | grep -v '[Ss]cheme' \
        | grep -v -e 'APFS Volume Preboot' -e 'APFS Volume Recovery' -e 'APFS Volume VM' -e "EFI  *EFI" -e '^[[:blank:]]*$'
    hr
    return
}
