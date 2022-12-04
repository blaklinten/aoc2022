#!/bin/bash

[ -z "$part" ] &&  {
  echo "Please specify which part to solve with the env. var. \$part"
  exit 1
}

part1()
{
  COUNT=0

  while read -r line; do
    INTERVAL_1="$(cut -d',' -f1 <<<"$line")"
    INTERVAL_2="$(cut -d',' -f2 <<<"$line")"

    seq "${INTERVAL_1%-*}" "${INTERVAL_1#*-}" | sort > sequence1
    seq "${INTERVAL_2%-*}" "${INTERVAL_2#*-}" | sort > sequence2

    FIRST_IN_SECOND="$(comm -32 sequence1 sequence2)"
    SECOND_IN_FIRST="$(comm -31 sequence1 sequence2)"

    if [ -z "$FIRST_IN_SECOND" ] || [ -z "$SECOND_IN_FIRST" ]; then
      COUNT=$((COUNT + 1))
    fi
  done <input.txt

  echo "$COUNT"
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
    sequence{1,2}
}

main
cleanup
