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
        str+="${arr[$i]}....\r"
    done
    str+="...."
    for ((j=((${#arr[@]} - 1)); j>=0; j--)); do
        str+="$(rev < <(echo ${arr[$j]}))"
        if [[ "$j" != 0 ]]; then
            str+="\r...."
        fi
    done
    echo $str
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