#!/bin/bash
# Create mysqldump backups with given arguements
# Steven Fairchild 2021-04-20 updated 2021-06-01

# Set database and file variables
set_vars() {
    if [[ -z "$1" ]]; then
        echo -e "database name must be passed as first aurguement\nExiting..."
        exit 1
    fi
    if [[ -z "$2" ]]; then
        export BPATH="/data/raid1/backups/mariadb/"
    else
        BPATH="$2"
    fi
    mkdir -p "$BPATH"
    export SECONDS=0
    IFS=' ' read -ra DATABASE <<< "$1"
    export KEEP_DAYS="30"
    export red="\e[1;31m"
    export creset="\e[0m"
}

root_check() {
    if [[ "$(whoami)" != "root" ]]; then
        echo -e "\n${red}This script must be ran as root!\nExiting...${creset}\n"
        exit 0
    fi
}

usage() {
    echo -e "Script usage\n\n\
    \t--help or -h: print this message\n\n\
    \tFirst arguement must be database list inside quotes even if only one database is specified\n\
    \tSecond arguement is the backup path. If none is specified then the internal setting is used\n
    \tExample 1: ./mysql_backup.sh \"database1 database2 database3\" /backup/path
    \tExample 2: ./mysql_backup.sh database"
}

elapsed_time() {
    MINUTES=$(echo "scale=2;$SECONDS/60" | bc -l)
    if [[ "$MINUTES" == 0 ]]; then
        logger -t "$0" "Completed in ${SECONDS} seconds"
        echo "Completed in ${SECONDS} seconds"
    else
        logger -t "$0" "Completed in ${MINUTES} minutes"
        echo "Completed in ${MINUTES} minutes"
    fi
}

rotate_daily() {
    daily_count="$(( $(ls ${BPATH}/daily | wc -l) / 2 ))"
    if [[ "$daily_count" -ge 2 ]]; then
        find "${BPATH}/daily" -iname "*.dump" -mtime 2 -exec mv {} "${BPATH}/weekly" \; 
        find "${BPATH}/daily" -mtime +1 -delete
    fi
}

rotate_weekly() {
    weekly_count="$(( $(ls ${BPATH}/weekly | wc -l) / 2 ))"
    if [[ "$weekly_count" -ge 7 ]]; then
        find "${BPATH}/weekly" -iname "*.dump" -mtime 7 -exec mv {} "${BPATH}/monthly" \; 
        find "${BPATH}/weekly" -mtime -7 -delete
    fi
}

rotate_monthly() {
    monthly_count="$(( $(ls ${BPATH}/monthly | wc -l) / 2 ))"
    if [[ "$monthly_count" -ge 30 ]]; then
        find "${BPATH}/monthly" -iname "*.dump" -mtime 30 -exec mv {} "${BPATH}/yearly" \;
        find "${BPATH}/monthly" -mtime +30 -delete
    fi
}

rotate_files() {
    for d in daily weekly monthly yearly; do
        mkdir -p "${BPATH}/${d}"
    done
    rotate_daily
    rotate_weekly
    rotate_monthly
    logger -t "$0" "Files rotated in ${BPATH}"
}

make_backups() {
    cd /tmp # /tmp is a tmpfs filesystem on modern distrobutions, by default it is half the size of the total memory.
            # if the backup is larger than half the memory size, it will fail before completing (or start swapping).
    # create dump file
    for db in "${DATABASE[@]}"; do
        FILE="${db}-$(date +%F).dump"
        mysqldump ${db} > "${FILE}"
        echo "gzipping ${FILE}... this may take some time"
        pigz -q "${FILE}"
        if [[ "$?" -eq 0 ]] && [[ -f "${FILE}.gz" ]]; then
            echo "Successfully compressed ${FILE}.gz"
            sha256sum "${FILE}.gz" > "${FILE}.gz.sha256"
            # Move to permanent backup directory
            mv "${FILE}.gz" "${BPATH}"
            mv "${FILE}.gz.sha256" "${BPATH}"
            echo "Successfully created backup of ${db} located at ${BPATH}${FILE}.gz"
            logger -t "mysql_backup.sh" "Successfully created backup of ${db} located at ${BPATH}${FILE}.gz"
        else
            echo "Failed to create ${FILE}.gz"
        fi
    done
}

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]] || [[ -z "$1" ]]; then
    usage
else
    root_check
    set_vars "$1" "$2"
    make_backups
    elapsed_time
fi

exit 0
