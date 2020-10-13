#!/bin/bash
# Provides CPU and GPU temperature
clockSpeed="$(/usr/bin/vcgencmd measure_clock arm)"
vc="/usr/bin/vcgencmd"
#getCelsius () {
	# Function is in progress, does not work.
	#cNum=$(/usr/bin/vcgencmd measure_temp | grep -Eo '[0-9]')
	#echo $cNum
#}
getFahrenheit () {
	#fDegree="(($(/usr/bin/vcgencmd measure_tmp) * (( 9 / 5 )) + 32 ))"
	#echo "$fDegree"
	cpuTemp="$(</sys/class/thermal/thermal_zone0/temp)"
	echo "CPU: $((cpuTemp / 1000)) c"
	fDegree=$(( $((cpuTemp / 1000)) * 9/5 + 32))
	echo "CPU: $(( $((cpuTemp / 1000)) * 9/5 + 32)) f"
}
#getCelsius
echo "========================================================="
echo "$HOSTNAME clockspeed: $clockSpeed"
getFahrenheit
exit 0
