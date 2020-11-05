#!/bin/bash
# Creates audio recordings 1 hour in length every hour
# Script file for use as systemd service
WDIR="/data/recordings/"
TIMESTAMP="$(/bin/date '+%Y-%m-%S %H:%M:%S')"

/usr/bin/systemd-cat -p info echo "listen.service: ## STARTING ##"
/usr/bin/systemd-cat -p info echo "listen.service: new recording at $TIMESTAMP"
/usr/bin/systemd-cat /usr/bin/arecord -f S16_LE --device="hw:1,0" -r 48000 -t wav --max-file-time 3600 --use-strftime "$WDIR"%Y-%m-%d/listen-%H-%M-%S.wav
/usr/bin/systemd-cat -p info "listen.service: ## STOPPING ##"
exit 0
