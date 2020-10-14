#!/bin/bash
# Provides CPU and GPU temperature
# Provide time in minutes to run for that amount of time
clockSpeed="$(/usr/bin/sudo cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq)"
getFahrenheit () {
	cpuTemp="$(</sys/class/thermal/thermal_zone0/temp)"
	echo "CPU: $((cpuTemp / 1000)) c"
	fDegree=$(( $((cpuTemp / 1000)) * 9/5 + 32))
	echo "CPU: $(( $((cpuTemp / 1000)) * 9/5 + 32)) f"
}
hostInfo () {
	echo "Hostname: $HOSTNAME CPU clockrate: $clockSpeed MHz"
	echo "========================================================="
}
if [[ $1 -gt 0 ]]; then
	counter=$(( $1 * 60 ))
	condition=$(( $1 * 2 ))
	echo "Executing for $1 minutes..."
	for (( i = 0; i < $condition; i++ )); do
		echo "$counter seconds remaining."
		getFahrenheit
		date +%T\ %F
		hostInfo
		sleep "30"
		counter=$(( $counter-30 ))
	done
else

	getFahrenheit; date +%T\ %F
	hostInfo
fi
exit 0
