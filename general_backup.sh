#!/bin/bash
# Created to allow full backing up of user specified source and destination folder, and amount of time to keep backups for

src_dir="/srv/www"
dst_dir="/home/sfairchild/shell_scripts/backups"
file_prefix="$(hostname)_website"
enable_cleanup=1
if [[ ${enable_cleanup} == 1 ]]; then
    keep_days=30
fi
final_backup="${dst_dir}/${file_prefix}-$(date +%F).tar.xz"
mkdir -p ${dst_dir}
shopt -s expand_aliases
alias logger='logger --tag general_backup.sh'

cleanup_backups() {
    files=$(find ${dst_dir} -mtime +"${keep_days}")
    if [[ ! -z $files ]]; then
        logger -p info "Deleting these files..."
        for file in $files; do
            logger -p info "Deleting - ${file}"
        done        
        if find ${dst_dir} -mtime +${keep_days} -delete; then
            logger -p info "Successfully deleted backup images older than ${keep_days}"
        else
            logger -s -p err "Failed to delete backup images older than ${keep_days}"
        fi
    else
        logger -p info "No image files older than ${keep_days} days were found"
    fi
}

main() {
    if tar cJf ${final_backup} ${src_dir}; then
        logger -p info "Successfully created ${final_backup}"
    else
        logger -p err "Failed to create ${final_backup}"
    fi
    if [[ ${enable_cleanup} == 1 ]]; then
        cleanup_backups
    fi
}

main