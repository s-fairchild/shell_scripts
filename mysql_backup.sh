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
        usage
        echo "Second arguement must be the backup destination root folder with no trailing forward slash."
    else
        export BPATH="${2}"
    fi
    for d in daily weekly monthly yearly; do
        mkdir -p "${BPATH}/${d}"
    done
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
    \tExample 1: ./mysql_backup.sh \"database1 database2 database3\" /backup/path -- NO TRAILING FORWARD SLASH
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
    if [[ "$daily_count" -ge 7 ]]; then
        find "${BPATH}/daily" -iname "*.dump.gz*" -daystart -mtime -7 | xargs -d "\n" tar -cf "${BPATH}/weekly/${DATABASE}_$(date -d '7 days ago' +%F).tar" &> /dev/null
        find "${BPATH}/daily" -iname "*.dump.gz*" -daystart -mtime +0 -delete
    fi
}

rotate_weekly() {
    weekly_count="$(ls ${BPATH}/weekly | wc -l)"
    if [[ "$weekly_count" -ge 4 ]]; then
        MBPATH="${BPATH}/monthly/$(date +%B)"
        mkdir -p "$MBPATH"
        find "${BPATH}/weekly" -iname "*.tar" -exec mv -t "${MBPATH}" {} \;
    fi
}

rotate_monthly() {
    monthly_count="$(ls ${BPATH}/monthly | wc -l)"
    if [[ "$monthly_count" -ge 12 ]]; then
        find "${BPATH}/monthly/$(date +%B)" -iname "*.tar" -daystart -mtime +365 -exec mv -t "${BPATH}/yearly" {} \;
    fi
}

rotate_files() {
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
        mysqldump "${db}" > "${FILE}"
        echo "gzipping ${FILE}... this may take some time"
        pigz -q "${FILE}"
        if [[ "$?" -eq 0 ]] && [[ -f "${FILE}.gz" ]]; then
            echo "Successfully compressed ${FILE}.gz"
            sha256sum "${FILE}.gz" > "${FILE}.gz.sha256"
            # Move to permanent backup directory
            mv "${FILE}.gz" "${BPATH}/daily/"
            mv "${FILE}.gz.sha256" "${BPATH}/daily/"
            echo "Successfully created backup of ${db} located at ${BPATH}/daily/${FILE}.gz"
            logger -t "mysql_backup.sh" "Successfully created backup of ${db} located at ${BPATH}/daily/${FILE}.gz"
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
    #rotate_files
    find "${BPATH}/daily" -mtime +365 -delete
    elapsed_time
fi

exit 0
