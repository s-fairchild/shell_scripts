#!/bin/bash
# https://www.codewars.com/kata/56dbe0e313c2f63be4000b25
# Moves in squared strings Kata from codewars
oper () {
	local fct=$1
	local s=$2
	if [ $fct == "vert_mirror" ]
	then
		IFS=',' read -ra sArr <<< "$s"
	fi

	for item in ${sArr[@]}
	do
		printf "   %s\n" $(echo $item | rev)
	done
}
echo "original string: $2"
#sArr=$(oper $1 $2)
oper $1 $2
printf "mirror string: "
exit 0
