#!/bin/bash
# Author: David Spreekmeester @aapit

# Asserts, pre-init
err_file_form="Provide a .tgz.asc file as argument."
err_404="Can't find file '$1'."
[[ -z "$1" ]] && echo "${err_file_form}" && exit
[[ ! -f "$1" ]] && echo "${err_404}" && exit

# Vars
basename=`echo $1 | awk '{print substr($0, 0, length($0) - 8)}'`
unlock_dir="${basename}"
decr_arch="${basename}.tgz"

# Asserts, pre-run
extension=`echo $1 | awk '{print substr($0, length($0) - 7)}'`
[[ ".tgz.asc" = "$extension" ]] || \
    (echo "Provide a .tgz.asc file as argument." && exit)

[[ -d "${unlock_dir}" ]] && \
    echo "Directory ${unlock_dir} already exists. Exiting." && exit

# Run
mkdir "${unlock_dir}" \
    && (chattr +C $unlock_dir \
        && gpg -d -o "$unlock_dir/${decr_arch}" $1 \
        && cd $unlock_dir \
        && tar -zxvf "${decr_arch}" \
        && rm "$decr_arch") \
    || rm -f "${unlock_dir}"
cd -
