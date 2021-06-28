#!/bin/bash
# Provides CPU and GPU temperature
# Provide time in minutes to run for that amount of time
clockSpeed="$(/usr/bin/sudo cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq)"
clockSpeed="$(( $clockSpeed / 1000 ))"
getFahrenheit () {
	cpuTemp="$(</sys/class/thermal/thermal_zone0/temp)"
	echo "CPU: $((cpuTemp / 1000)) c"
	fDegree=$(( $((cpuTemp / 1000)) * 9/5 + 32))
	echo "CPU: $(( $((cpuTemp / 1000)) * 9/5 + 32)) f"
}
hostInfo () {
	echo "Hostname: $HOSTNAME CPU clockrate: $clockSpeed MHz"
}
time="Time and Date: $(date +%T\ %F)"
if [[ $1 -gt 0 ]]; then
	counter=$(( $1 * 60 ))
	condition=$(( $1 * 2 ))
	echo "Executing for $1 minutes..."
	for (( i = 0; i < $condition; i++ )); do
		echo "========================================================="
		echo "$counter seconds remaining."
		echo "$time"
		hostInfo
		getFahrenheit
		sleep "30"
		counter=$(( $counter-30 ))
	done
	echo "Completed at $time"
	echo "Final readings: "
        getFahrenheit	
	hostInfo
else
	hostInfo
        echo "$time"
	getFahrenheit
fi
exit 0
