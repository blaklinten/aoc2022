#!/bin/bash

[ -z "$part" ] &&  {
  echo "Please specify which part to solve with the env. var. \$part"
  exit 1
}

get_ASCII_value()
{
  CHAR="$1"
  DECIMAL_VALUE=$(echo -n "$CHAR" | od -A n -t d1)
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
  echo "$ASCII_VALUE"
}

write_to_file()
{
  INPUT="$1"
  NAME="$2"
    while read -r -n1 char; do
      echo "$char" >> "$NAME"
    done <<<"$INPUT"
}

part1()
{
  while read -r line; do
    COMPARTMENT_SIZE=$(($(echo -n "$line" | wc -c) / 2))

    write_to_file "$(echo -n "$line" | cut -c $(seq -s, $COMPARTMENT_SIZE))" "FIRST_HALF"
    sort FIRST_HALF > FIRST_HALF_SORTED
    rm FIRST_HALF

    write_to_file "$(echo -n "$line" | cut -c $(seq -s, $COMPARTMENT_SIZE) --complement)" "SECOND_HALF"
    sort SECOND_HALF > SECOND_HALF_SORTED
    rm SECOND_HALF

    comm -12 FIRST_HALF_SORTED SECOND_HALF_SORTED >> duplicates
  done <input.txt

  PRIORITY_POINTS=0
  while read -r char; do
    [ -z "$char" ] && continue

    ASCII_VALUE="$(get_ASCII_value "$char")"
    PRIORITY_POINTS=$((PRIORITY_POINTS + ASCII_VALUE))
  done <<<"$(uniq duplicates)"
  echo "$PRIORITY_POINTS"
}

part2()
{
  COUNT=1
  PRIORITY_POINTS=0
  while read -r line; do

    write_to_file "$line" "LINE$COUNT"
    sort -u "LINE$COUNT" > "LINE${COUNT}_SORTED"

    if [ "$COUNT" = 3 ]; then
      comm -12 LINE1_SORTED LINE2_SORTED > INTERMEDIATE_COMPARISON
      GROUP_BADGE_TYPE="$(comm -12 INTERMEDIATE_COMPARISON LINE3_SORTED | tail -n1)"

      ASCII_VALUE="$(get_ASCII_value "$GROUP_BADGE_TYPE")"
      PRIORITY_POINTS=$((PRIORITY_POINTS + ASCII_VALUE))

      rm \
        LINE1 \
        LINE2 \
        LINE3 \
        LINE1_SORTED \
        LINE2_SORTED \
        LINE3_SORTED \
        INTERMEDIATE_COMPARISON 

      COUNT=0
    fi
    COUNT=$((COUNT + 1))
  done <input.txt

  echo "$PRIORITY_POINTS"
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
    duplicates \
    LINE1 \
    LINE2 \
    LINE3 \
    LINE1_SORTED \
    LINE2_SORTED \
    LINE3_SORTED \
    INTERMEDIATE_COMPARISON 
}

main
cleanup
