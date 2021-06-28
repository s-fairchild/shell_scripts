#!/bin/bash
# Created by Steven Fairchild on 2021-06-28 to create a regular rotation of filesystem images

# Set variables
src_dev="/dev/sda"
img_dest="/data/raid5/backups/local_images"
img_name="$(hostname)_src_dev_$(date +%F)"
img_final="${img_dest}/${img_name}.img.gz"
img_hash="${img_final}.sha256"
# Number of days to keep backup files. Files older than X days will be deleted. Set to -1 to keep forever.
keep_days=30
# DO NOT CHANGE. Used for elapsed time measurement.
SECONDS=0

# Set logger tag and make backup destination directory
shopt -s expand_aliases
alias logger='logger --tag image_backup.sh'
mkdir -p ${img_dest}

make_img() {
    if dd if=${src_dev} | pigz > ${img_final}; then
        logger -p info "Successfully created gzip compressed image backup of ${src_dev} at ${img_final}"
    else
        logger -s -p err "Failed to create gzip compressed image backup of ${src_dev} at ${img_final}"
        exit 1
    fi
}
make_hash() {
    if sha256sum ${img_final} > ${img_hash}; then
        logger -p info "Successfully created sha256sum hash at ${img_hash}"
    else
        logger -s -p error "Failed to create sha256sum hash at ${img_hash}"
        exit 1
    fi
}
cleanup_backups() {
    if [[ keep_days > 0 ]]; then
        files=$(find ${img_dest} -mtime +${keep_days})
        if [[ ! -z $files ]]; then
            logger -p info "Deleting these files..."
            for file in $files; do
                logger -p info "Deleting - ${file}"
            done
            if find ${img_dest} -mtime +${keep_days} -delete; then
                logger -p info "Successfully deleted backup images older than ${keep_days}"
            else
                logger -s -p err "Failed to delete backup images older than ${keep_days}"
            fi
        fi
    fi
}
elapsed_time() {
    MINUTES=$(echo "scale=2;$SECONDS/60" | bc -l)
    if [[ "$MINUTES" == 0 ]]; then
        logger -p info "${1} created in ${SECONDS} seconds"
    else
        logger -p info "${1} created in ${MINUTES} minutes"
    fi
    export SECONDS=0
}
main() {
    make_img
    elapsed_time ${img_final}
    make_hash
    elapsed_time ${img_hash}
    cleanup_backups
}

if main; then
    logger -p info "Completed Successfully"
    exit 0
else
    logger -s -p err "Failed to create image backup"
    exit 1
fi