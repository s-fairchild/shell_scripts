#!/bin/bash
# Create mysqldump backups with given arguements
# Steven Fairchild 2021-04-20
red="\e[1;31m"
creset="\e[0m"
if [[ "$(whoami)" != "root" ]]; then
    echo -e "\n${red}This script must be ran as root!\nExiting...${creset}\n"
    exit 0
fi
if [[ -z "$1" ]]; then
    echo -e "database name must be passed as first aurguement\nExiting..."
    exit 0
fi

cd /tmp # /tmp is a tmpfs filesystem on modern distrobutions, by default it is half the size of the total memory.
        # if the backup is larger than half the memory size, it will fail before completing (or start swapping).

# Set database and file variables
DATABASE=$1
BPATH=/data/backups/mariadb/$DATABASE
FILE=$DATABASE-$(date +%F).sql
USER="root"
PASS="password"
KEEP_DAYS="30"

# Create backup folder if it doesn't exist
if [[ ! -d "$BPATH" ]]; then
    mkdir -p "$BPATH"
fi

# create dump file
mysqldump --opt --user=${USER} --password=${PASS} ${DATABASE} > ${FILE}

# Gzip compress and create sha1 hash
pigz -q $FILE
sha1sum $FILE.gz > $FILE.gz.sha1

# Delete backups if they already exist for today
if [[ -f "$BPATH/$FILE.gz" ]] || [[ -f "$BPATH/$FILE.gz.sha1sum" ]]; then
    rm "$BPATH/$FILE.gz"
    rm "$BPATH/$FILE.gz.sha1"
fi

# Move to permanent backup directory
mv $FILE.gz $BPATH
mv $FILE.gz.sha1 $BPATH

echo "Successfully created backup of $DATABASE located at $BPATH/$FILE.gz"
logger "Successfully created backup of $DATABASE located at $BPATH/$FILE.gz"
echo -e "${red}Deleting files older than $KEEP_DAYS days in $BPATH${creset}"
find "$BPATH" -mtime +"$KEEP_DAYS" -print
echo -e "${red}Files shown will be deleted${creset}"
find "$BPATH" -mtime +"$KEEP_DAYS" -delete
logger "Deleted files older than $KEEP_DAYS days in $BPATH"
cd - # Return to original directory
exit 0