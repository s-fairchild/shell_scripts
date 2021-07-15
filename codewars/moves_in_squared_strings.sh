#!/bin/bash
# Steven Fairchild 2021-07-15
# To view the kata "Moves in squared strings (III)": https://www.codewars.com/kata/56dbeec613c2f63be4000be6/train/shell

#export s="abcd\nefgh\nijkl\nmnop"
# s="weetvI\ruNhBWF\rUHiTNk\ryWflpG\rPxmFdj\rCwiIvZ"
# diag_1_sym(s) => "aeim\nbfjn\ncgko\ndhlp"

diag_1_sym() {
    #s=$(echo $1 | sed -e 's/\\n/\,/g')
    #IFS=' ' read -r -a blocks <<< "$1"
    declare -a blocks
    for word in $1; do
      blocks+=($word)
    done
    for ((j=0; j<=${#blocks[0]}; j++)); do
        for ((i=0; i<=${#blocks[@]}; i++)); do
            str+=${blocks[$i]:$j:1}
        done
        if [[ $j -lt $((${#blocks[0]} - 1)) ]]; then
            str+="\r"
        fi
    done
    echo -n $str
}

# takes two parameters, 1: function, 2: string
oper() {
    #
    if [[ "$1" == "diag_1_sym" ]]; then
        diag_1_sym "$2"
    fi
    echo
}
oper "$1" "$2"

exit 0