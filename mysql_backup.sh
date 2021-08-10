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
        logger -t "mysql_backup.sh" "Completed in ${SECONDS} seconds"
        echo "Completed in ${SECONDS} seconds"
    else
        logger -t "mysql_backup.sh" "Completed in ${MINUTES} minutes"
        echo "Completed in ${MINUTES} minutes"
    fi
}

main() {
    cd /tmp # /tmp is a tmpfs filesystem on modern distrobutions, by default it is half the size of the total memory.
            # if the backup is larger than half the memory size, it will fail before completing (or start swapping).
    # create dump file
    for db in "${DATABASE[@]}"; do
        FILE="${db}-$(date +%F).dump"
        mysqldump ${db} > "${FILE}"
        echo "gzipping ${FILE}... this may take some time"
        pigz -q ${FILE}
        if [[ ${?} -eq 0 ]] && [[ -f "${FILE}.gz" ]]; then
            echo "Successfully compressed ${FILE}.gz"
            sha1sum "${FILE}.gz" > "${FILE}.gz.sha1"
            # Move to permanent backup directory
            mv ${FILE}.gz ${BPATH}
            mv ${FILE}.gz.sha1 ${BPATH}
            echo "Successfully created backup of ${db} located at ${BPATH}${FILE}.gz"
            logger -t "mysql_backup.sh" "Successfully created backup of ${db} located at ${BPATH}${FILE}.gz"
        else
            echo "Failed to create ${FILE}.gz"
        fi
    done

    echo -e "${red}Deleting files older than ${KEEP_DAYS} days in ${BPATH}${creset}"
    find "${BPATH}" -mtime +"${KEEP_DAYS}" -print
    echo -e "${red}Files shown will be deleted${creset}"
    find "${BPATH}" -mtime +"${KEEP_DAYS}" -delete
    logger -t "mysql_backup.sh" "Deleted files older than ${KEEP_DAYS} days in ${BPATH}"
    cd - # Return to original directory
    history -c # stop history from saving password if provided
    elapsed_time
}

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    usage
else
    root_check
    set_vars "$1"
    main
fi

exit 0
