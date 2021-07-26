#!/bin/bash
# Steven Fairchild 2021-07-26
# https://www.codewars.com/kata/525f47c79f2f25a4db000025

validate_phone() {
    p=$(echo "$1" | tr -d \( ); p=$(echo "$p" | tr -d \) ); p=($(echo "$p" | tr '-' ' '))
    if [[ "${p[@]}" =~ [:alpha:] ]] || [[ "${#p[@]}" != 3 ]]; then
        echo "False"; exit
    fi
    for index in ${!p[@]}; do
        if [[ "${p[$index]:0:1}" == 0 ]] && [[ "$index" -eq 0 ]]; then
            echo "False"; exit
        elif [[ "${#p[$index]}" > 3 ]] && [[ "$index" -eq 0 ]]; then
            echo "False"; exit
        elif [[ "${#p[$index]}" > 4 ]]; then
            echo "False"; exit
        else
            echo "True"; exit
        fi
    done
}

validate_phone "$1"