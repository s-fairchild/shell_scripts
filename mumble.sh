#!/bin/bash
# Kata: https://www.codewars.com/kata/5667e8f4e3f572a8f2000039/train/shell
accum () {
    local end="${#1}"; local str="${1,,}"
    for ((i=0,j=$end; i < ${#str}; i++)); do
        let "j+=i+1"
        while [ $j -ne "$end" ]; do
            local array[$i]+="$(echo ${str:$i:1})"
            let "j--";
        done
        array[$i]=$(echo ${array[$i]^})
    done
    local string; local count=0
    for i in ${array[@]}; do
        if [ $count -eq $end ] || [ $count -eq 0 ]; then
            string+=$i
        else
            string+="-$i"
        fi
        let "count++"
    done
    echo $string
}
echo $(accum "$1")