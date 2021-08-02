#!/bin/bash
# ROT13 is a simple letter substitution cipher that replaces a letter with the letter 13 letters after it in the alphabet. ROT13 is an example of the Caesar cipher.
# https://www.codewars.com/kata/530e15517bc88ac656000716/shell
# Steven Fairchild 2021-08-03

a2i() {
    printf '%d\n' "'$1"
}
i2a() {
    printf "\x$(printf %x $1)\n"
}

rot13() {
    s="$1"; declare -a tmp
    for (( i=0; i<${#s}; i++ )); do
        c="$(a2i ${s:$i:1})"
        if [[ "$c" -le 109 ]] && [[ "$c" -ge 97 ]] || [[ "$c" -le 77 ]] && [[ "$c" -ge 65  ]]; then
            tmp+="$(i2a $(( c + 13 )) )"
        elif [[ "$c" -gt 110 ]] && [[ "$c" -le 122  ]] && [[ "$c" -le 90 ]] || [[ "$c" -gt 78 ]]; then
            tmp+="$(i2a $(( c - 13 )) )"
        else
            tmp+="${s:$i:1}"
        fi
    done
    echo "${tmp[@]}"
}

rot13 "$1"
exit 0