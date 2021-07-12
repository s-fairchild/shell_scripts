#!/bin/bash
# Written by Steven Fairchild 2021-07-12
# Automate server backups with duplicity

# Directories to backup
sources="/home /opt /data/raid6 /root /usr/bin/local /etc /usr/lib/mariadb"
# Destentation for backups
dest="/data/raid1/backups/$(hostname)"
# Directories to exclude
excluded="/data/raid6/share"
# Boolean value to keep or delete backups older than a certian age
del_old_backups=1
# Keep time
if [[ $del_old_backups == 1 ]]; then
    keep_time="2M"
fi
# Make a full backup at this interval
full_time="1M"
# Logfile to use
log_file="/var/log/duplicity/duplicity.log"
# Name of backups
name=$(hostname)
# Create missing directories if they don't exist
mkdir -p /var/log/duplicity
mkdir -p ${dest}
# Symmetric gpg encryption password
PASSPHRASE="password"

for exc in $excluded; do
    all_dirs+="--exclude ${exc}"
done

for src in $sources; do
    all_dirs+="--include ${src} "
done

all_dirs+="file://${dest}"

if duplicity --name ${name} --full-if-older-than ${full_time} --tempdir=/tmp --log-file ${log_file} ${all_dirs}; then
    if [[ $del_old_backups == 1 ]]; then
        if duplicity remove-older-than ${keep_time} file://${dest} --force --log-file ${log_file}; then
            exit 0
        else
            exit 1
        fi
    fi
else
    exit 1
fi