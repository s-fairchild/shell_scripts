#!/bin/bash
# Steven Fairchild 2021-07-21
# Moves in squared strings (II) https://www.codewars.com/kata/56dbe7f113c2f63570000b86
# Not used
# repeat() {
#     for ((i="$1"; i>0; i--)); do
#         echo -n '.'
#     done
# }
rot() {
    IFS=',' read -ra arr <<< "$1"
    i=0
    for ((j=((${#arr[@]} - 1)); j>=0; j--)); do
        nArr[$i]="$(rev < <(echo ${arr[$j]}))"
        ((i=i+1))
    done
    echo "$(echo ${nArr[@]} | tr ' ' '\r')"
}
selfieAndRot() {
    IFS=',' read -ra arr <<< "$1"
    for i in ${!arr[@]}; do
        for ((j="${#arr[@]}"; j>0; j--)); do
            arr[$i]+='.'
        done
    done
    i="${#arr[@]}"
    for ((j=${#arr[@]}; j>=0; j--)); do
        arr[$i]="$(rev < <(echo ${arr[$j]}))"
        ((i=i+1))
    done
    echo "$(echo ${arr[@]} | tr ' ' '\r')"
}
oper() {
    if [[ "$1" == "rot" ]]; then
        rot $2
    elif [[ "$1" == "selfieAndRot" ]]; then
        selfieAndRot $2
    else
        echo "Arguement error"
    fi
}
oper $1 $2