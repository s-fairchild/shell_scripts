#!/bin/bash
# Steven Fairchild 2021-07-27
# https://www.codewars.com/kata/5d2d0d34bceae80027bffddb

# "a e ii ooo u" == "ooo ii a e u"
count_vowels() {
    s=( $(echo "$1" | tr ' ' '\n') )
    declare -a vc
    for i in "${!s[@]}"; do
        vc["$i"]=$(echo "${s[$i]}" | tr -cd '[aeiouAEIOU]' | wc -m)
    done

    for (( i=0; i<"${#vc[@]}"; i++ )); do
        for (( j="$i"; j<"${#vc[@]}"; j++ )); do
            if [[ "${vc[$i]}" < "${vc[$j]}" ]]; then
                tmp="${s[$j]}"; vctmp="${vc[$j]}"
                unset "s[$j]"; unset "vc[$j]"
                s=( "$tmp" "${s[@]}" ); vc=( "$vctmp" "${vc[@]}" )
            fi
        done
    done
    echo "${s[@]}"
}

count_vowels "$1"