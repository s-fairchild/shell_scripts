#!/bin/bash
# Steven Fairchild 2021-07-21
# Moves in squared strings (II) https://www.codewars.com/kata/56dbe7f113c2f63570000b86

# "rot", "fijuoo,CqYVct,DrPmMJ,erfpBA,kWjFUG,CVUfyL", "LyfUVC\rGUFjWk\rABpfre\rJMmPrD\rtcVYqC\rooujif"
rot() {
    echo "Not Implimented yet."
}
# selfieAndRot" "xZBV,jsbS,JcpN,fVnP" "xZBV....\rjsbS....\rJcpN....\rfVnP....\r....PnVf\r....NpcJ\r....Sbsj\r....VBZx"
selfieAndRot() {
    IFS=',' read -ra arr <<< "$1"
    for i in ${!arr[@]}; do
        arr[$i]="${arr[$i]}...."
    done
    declare -a results; i="${#arr[@]}"
    for ((j=((${#arr[@]} - 1)); j>=0; j--)); do
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