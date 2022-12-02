#!/bin/bash

INPUT="input.txt"
TEST="test_input.txt"

is_current_bigger() {
    [ "$1" -gt "$2" ] && echo "yes" || echo "no"
}

part_1() {
    echo "Part 1"
    previous="$(head -n1 $1)"

    while IFS= read -r number || [ -n "$number" ]; do
        [ "$(is_current_bigger $number $previous)" = "yes" ] && total=$((total + 1))
        previous="$number"
    done < "$1"
    echo "$total"
}

part_2() {
    echo "Part 2"

    total=0
    while IFS= read -r number || [ -n "$number" ]; do

        [ -z "$second_offset" ] && {
            second_offset="$first_offset"
            first_offset="$number"
            continue
        }

        current_window=$((second_offset + first_offset + number))

        [ -z "$previous_window" ] && {
            previous_window="$current_window"
            second_offset="$first_offset"
            first_offset="$number"
            continue
        }

        [ "$(is_current_bigger $current_window $previous_window)" = "yes" ] && total=$((total + 1))
        
        second_offset="$first_offset"
        first_offset="$number"
        previous_window="$current_window"
    done < "$1"
    echo "$total"
}

solve() {
    [ "$part" = "part1" ] && part_1 "$1" || part_2 "$1"
}
solve "$INPUT"
