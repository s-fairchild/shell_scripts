#!/bin/bash
# Steven Fairchild 2021-07-21
rot_90_clock() {

}
diag_1_sym() {

}
selfie_and_diag1() {

}
# takes two parameters, 1: function, 2: string
oper() {
    if [[ "$1" == "rot_90_clock" ]]; then
        rot_90_clock $2
    elif [[ "$1" == "diag_1_sym" ]]; then
        diag_1_sym $2
    elif [[ "$1" == "selfie_and_diag1" ]]; then
        selfie_and_diag1 $2
    else
        echo "Arguement error"
    fi
}
oper "$1" "$2"