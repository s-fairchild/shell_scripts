#!/bin/bash
# https://www.codewars.com/kata/51f2b4448cadf20ed0000386

deanchor() {
    echo $(echo "$1" | cut -d \# -f 1)
}

deanchor "$1"