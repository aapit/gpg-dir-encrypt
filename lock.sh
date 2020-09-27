#!/bin/bash
# Author: David Spreekmeester @aapit

# Init
recipient="$GPG_ENCRYPT_ARCHIVE_RECIPIENT"

# Asserts
[[ -z "$1" ]] && echo "Provide the dir name as argument." && exit
[[ -z "$recipient" ]] && \
    echo "No recipient provided." && \
    echo "Set GPG_ENCRYPT_ARCHIVE_RECIPIENT as environment variable." && \
    exit
[[ ! -d "$1" ]] && echo "$1 is not a dir." && exit
[[ ! -w "$1" ]] && echo "$1 is not writable." && exit

# Run
echo "Encrypting '$1' for $recipient"
tar -zcvf "$1.tgz" "$1" && \
    gpg -e -a -r "$recipient" "$1.tgz"
    rm "$1.tgz"

read -rep "Shred source folder '$1'? [y/N] " deletion
[[ "y" = "$deletion" ]] && (find "$1" -type f -exec shred -u {} \; && rm -rf "$1" && echo "Shredded $1.")
