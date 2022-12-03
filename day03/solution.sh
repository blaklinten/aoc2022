#!/bin/bash

[ -z "$part" ] &&  {
  echo "Pleas specify which part to solve with the env. var. \$part"
  exit 1
}

part1()
{
  while read -r line; do
    COMPARTMENT_SIZE=$(($(echo -n "$line" | wc -c) / 2))

    FIRST_HALF=$(echo -n "$line" | cut -c $(seq -s, $COMPARTMENT_SIZE))
    while read -r -n1 char; do
      echo "$char" >> FIRST_HALF
    done <<<"$FIRST_HALF"
    sort FIRST_HALF > FIRST_HALF_SORTED
    rm FIRST_HALF

    SECOND_HALF=$(echo -n "$line" | cut -c $(seq -s, $COMPARTMENT_SIZE) --complement)
    while read -r -n1 char; do
      echo "$char" >> SECOND_HALF
    done <<<"$SECOND_HALF"
    sort SECOND_HALF > SECOND_HALF_SORTED
    rm SECOND_HALF

    comm -12 FIRST_HALF_SORTED SECOND_HALF_SORTED >> duplicates
  done <input.txt

  PRIORITY_POINTS=0
  while read -r char; do
    [ -z "$char" ] && continue

    DECIMAL_VALUE=$(echo -n "$char" | od -A n -t d1)
    # a-z -> 97-122, A-Z -> 65-90 in decimal
    LOWER_CASE_BREAK_POINT=97
    LOWER_CASE_BASE_PRIORITY=1
    UPPER_CASE_BREAK_POINT=65
    UPPER_CASE_BASE_PRIORITY=27

    if [ "$DECIMAL_VALUE" -gt $LOWER_CASE_BREAK_POINT ]; then # 97 is lowest decimal value for lower case letters 
      ASCII_VALUE=$((DECIMAL_VALUE - LOWER_CASE_BREAK_POINT + LOWER_CASE_BASE_PRIORITY)) # reduce value to get priority 1-26
    else
      ASCII_VALUE=$((DECIMAL_VALUE - UPPER_CASE_BREAK_POINT + UPPER_CASE_BASE_PRIORITY)) # reduce value to get priority 27-52
    fi

    PRIORITY_POINTS=$((PRIORITY_POINTS + ASCII_VALUE))
  done <<<"$(uniq duplicates)"
  echo "$PRIORITY_POINTS"
}

part2()
{
  echo Part2
}

main()
{
  if [ "$part" = "part1" ]; then
    part1
  else
    part2
  fi
}

cleanup()
{
  rm -f \
    FIRST_HALF_SORTED \
    SECOND_HALF_SORTED \
    duplicates
}

main
cleanup
