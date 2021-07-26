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
    if [[ "$1" == "selfie" ]]; then
        echo "${rev_sym[@]}"
    else
        echo "${rev_sym[@]}" | tr ' ' '\n'
    fi
}
# "abcd\nefgh\nijkl\nmnop" == "dhlp\ncgko\nbfjn\naeim"
rot_90_counter() {
    for char in "${arr[@]}"; do
        j="((${#arr[1]} - 1))"
        for (( i=0; i<"${#arr[@]}"; i++)); do
            rot["$i"]+=${char:$j:1}
            ((j--))
        done
    done
    if [[ "$1" == "selfie" ]]; then
        echo "${rot[@]}"
    else
        echo "${rot[@]}" | tr ' ' '\n'
    fi
}
# "abcd\nefgh\nijkl\nmnop" == "abcd|plhd|dhlp\nefgh|okgc|cgko\nijkl|njfb|bfjn\nmnop|miea|aeim"
selfie_diag2_counterclock() {
    rot=( $(rot_90_counter "selfie") )
    sym=( $(diag_2_sym "selfie") )
    echo "${rot[@]}"
    echo "${sym[@]}"
    for (( i=0; i<"${#arr[@]}"; i++ )); do
        sd["$i"]="${arr[$i]}|${sym[$i]}|${rot[$i]}"
    done
    echo "${sd[@]}" | tr ' ' '\n'
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