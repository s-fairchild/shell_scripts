#!/bin/bash
# Written by Steven Fairchild on 2021-07-12
# This script is meant to be ran as a cron job to verify the integrity of your array. Once a month is the recommended interval.
# Visit the Linux raid wiki for more information: https://raid.wiki.kernel.org/index.php/Scrubbing_the_drives

array="md0"

if echo check > /sys/block/${array}/md/sync_action; then
    logger -p cron.err "Successfully started check on ${array}"
    exit 0
else
    logger -s -p cron.err "Error starting filesystem check for ${array}"
    exit 1
fi