#!/bin/bash
# Script that replaces all vowels from input string
if [ -n "$1" ];
then
	result=$(printf "$1" | sed -e 's/[aeiou]//gI' ) 
fi
echo "$result"
exit 0
