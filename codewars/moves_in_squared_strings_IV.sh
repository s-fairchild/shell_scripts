#!/bin/bash
# Steven Fairchild 2021-07-26

# "abcd\nefgh\nijkl\nmnop" == "plhd\nokgc\nnjfb\nmiea"
diag_2_sym() {
    for (( i="${#arr[@]}"; i>=0; i-- )); do
        for (( j=((${#arr[$i]} - 1)); j>=0; j-- )); do
            sym["$j"]+="${arr[$i]:$j:1}"
        done
    done
    k=0
    for (( i=((${#arr[@]} - 1)); i>=0; i-- )); do
        rev_sym["$i"]="${sym[$k]}"
        ((k++))
    done
    echo "${rev_sym[@]}" | tr ' ' '\n'
}
rot_90_counter() {
    echo "Not Implimented Yet."
}
selfie_diag2_counterclock() {
    echo "Not Implimented Yet."
}
oper() {
    export arr=( $(echo "$2" | sed 's/\\n/\n/g') )
    case "$1" in
    "diag_2_sym")
        diag_2_sym
        ;;
    "rot_90_counter")
        rot_90_counter
        ;;
    "selfie_diag2_counterclock")
        selfie_diag2_counterclock
        ;;
    *)
        echo "Arguement error."
        ;;
    esac
}

oper "$1" "$2"