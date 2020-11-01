#!/bin/bash
convert () {
    local month="${1,,}"
    case "$month" in
        "jan"|"january")
            month="01"
            ;;
        "feb"|"february")
            month="02"
            ;;
        "mar"|"march")
            month="03"
            ;;
        "apr"|"april")
            month="04"
            ;;
        "may")
            month="05"
            ;;
        "jun"|"june")
            month="06"
            ;;
        "jul"|"july")
            month="07"
            ;;
        "aug"|"august")
            month="08"
            ;;
        "sep"|"september")
            month="09"
            ;;
        "oct"|"october")
            month="10"
            ;;
        "nov"|"november")
            month="11"
            ;;
        "dec"|"december")
            month="12"
            ;;
        *)
    esac
    echo "$month"
}
echo "$(convert $1)"
exit 0