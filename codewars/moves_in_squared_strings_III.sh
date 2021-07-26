#!/bin/bash
# Steven Fairchild 2021-07-21
# "abcd\nefgh\nijkl\nmnop" == "miea\nnjfb\nokgc\nplhd"
rot_90_clock() {
    for sq in "${arr[@]}"; do
        for (( i="${#arr[@]}"; i>=0; i-- )); do
            sym["$i"]+="${sq:$i:1}"
        done
    done
    for index in "${!sym[@]}"; do
        sym["$index"]=$(echo "${sym[$index]}" | rev)
    done
    echo "${sym[@]}" | tr ' ' '\r'
}

# "abcd\nefgh\nijkl\nmnop" == "aeim\nbfjn\ncgko\ndhlp"
diag_1_sym() {
    for sq in "${arr[@]}"; do
        for (( i=0; i<"${#arr[@]}"; i++ )); do
            sym["$i"]+="${sq:$i:1}"
        done
    done
    echo "${sym[@]}" | tr ' ' '\r'
}
selfie_and_diag1() {
    echo "Not implimented"
}
oper() {
    export arr=( $(echo "$2" | sed 's/\\n/\n/g') )
    if [[ "$1" == "rot_90_clock" ]]; then
        rot_90_clock "$arr"
    elif [[ "$1" == "diag_1_sym" ]]; then
        diag_1_sym "$arr"
    elif [[ "$1" == "selfie_and_diag1" ]]; then
        selfie_and_diag1 "$arr"
    else
        echo "Arguement error"
    fi
}
oper "$1" "$2"