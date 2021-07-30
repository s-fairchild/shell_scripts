#!/bin/bash
# https://www.codewars.com/kata/515decfd9dcfc23bb6000006/shell

check_leading_zeros() {
    IFS='.' read -ra octets "$1"
    octets=($(echo $1 | tr "." "\n"))
    for octet in ${octets[@]}; do
        echo $octet
        if [[ "${octet:0:1}" -eq 0 ]] && [[ "${#octet}" -gt 1 ]]; then
            echo "False"
        fi
    done
}

validate_ipv4() {
    check_leading_zeros "$1"
    if echo "$1" | grep -E "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" &>> /dev/null; then
        echo "True"
    else
        echo "False"
    fi
}

validate_ipv4 "$1"