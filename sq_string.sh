#!/bin/bash -x
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
<<<<<<< HEAD
	if [ $1 == "vertMirror" ]; then
		local output=$(vertMirror)
	elif [ $1 == "horMirror" ]; then
		local output=$(horMirror)
=======
	if [ $1 == "vertMirror" ] && [ ! -z $1 ]; then
		final=$(vertMirror)
	elif [ $1 == "horMirror" ] && [ ! -z $1 ]; then
		final=$(horMirror)
	else
		echo "You must enter either vertMirror or horMirror followed be the string."
>>>>>>> 10c6486ef3e8e0d4db52a58ce2705fe060555b77
	fi
	echo $final
}
oper $1 $2
exit 0
