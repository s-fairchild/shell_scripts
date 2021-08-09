#!/bin/bash
# Steven Fairchild 2021-08-09
# Basics 08: Find next higher number with same Bits (1's) https://www.codewars.com/kata/56bdd0aec5dc03d7780010a5

next_highest_int() {
  bin1="$(echo "obase=2; $1" | bc)"
  bin1="$(echo $bin1 | tr -d 0 | wc -m)"
  num1="$1"
  declare -i bin2=0
  while [[ "$bin1" != "$bin2" ]]; do
    ((num1++))
    tmp="$(echo "obase=2; $num1" | bc)"
    bin2="$(echo $tmp | tr -d 0 | wc -m)"
  done
  echo "$num1"
}

next_highest_int "$1"