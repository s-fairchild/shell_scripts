#!/bin/bash
vertMirror() {
	for ((i=0; i < ${#origArr[@]}; i++)); do
                local sArr[$i]=$(echo ${origArr[$i]} | rev)
        done
	echo $(echo ${sArr[*]} | tr ' ' '\r')
}
horMirror() {
        local count=$((${#origArr[@]} - 1))
        for ((i=$count,j=0; i >= 0; i--,j++)); do
        	local sArr[$i]=${origArr[$j]}
        done
	echo $(echo ${sArr[*]} | tr ' ' '\r')
}
oper() {
	IFS=',' read -ra origArr <<< $2
	if [ $1 == "vertMirror," ]; then
		final=$(vertMirror)
	elif [ $1 == "horMirror," ]; then
		final=$(horMirror)
	else
		echo "error"
	fi
	echo $final
}
oper $1 $2
exit 0
