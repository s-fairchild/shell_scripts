#!/bin/bash
# Steven Fairchild 2021-07-27
# https://www.codewars.com/kata/526571aae218b8ee490006f4/shell

count_bits() {
    if [[ "$1" =~ [0-9] ]]; then
        bits=$(echo "obase=2;$1" | bc)
    else
        echo "Input must be a base 10 number."
    fi
    declare -i result=0
    for (( i=0; i<"${#bits}"; i++ )); do
        if [[ "${bits:$i:1}" -eq 1 ]]; then
            ((result++))
        fi
    done
    echo "$result"
}

count_bits "$1"