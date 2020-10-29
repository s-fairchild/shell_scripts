#!/bin/bash -x
vertMirror() {
	for ((i=0; i < ${#origArr[@]}; i++)); do
                sArr[$i]=$(echo ${origArr[$i]} | rev)
        done
	final=$(echo ${sArr[*]} | tr ' ' '\r')
}
horMirror() {
        local count=$((${#origArr[@]} - 1))
        for ((i=$count,j=0; i >= 0; i--,j++)); do
        	sArr[$i]=${origArr[$j]}
        done
	final=$(echo ${sArr[*]} | tr ' ' '\r')
}
oper() {
	IFS=',' read -ra origArr <<< $2
	if [ $1 == "vert_mirror" ]; then
		local output=$(vertMirror)
	elif [ $1 == "hor_mirror" ]; then
		local output=$(horMirror)
	fi
	#echo ${output[*]}
	echo $output
}
array=$(oper $1 $2)
exit 0
