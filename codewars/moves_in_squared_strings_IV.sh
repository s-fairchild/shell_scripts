#!/bin/bash
# Steven Fairchild 2021-07-26
diag_2_sym() {
    echo "Not Implimented Yet."
}
rot_90_counter() {
    echo "Not Implimented Yet."
}
selfie_diag2_counterclock() {
    echo "Not Implimented Yet."
}
oper() {
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
    esac
}

oper $1 $2