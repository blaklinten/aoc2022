#!/bin/bash

[ -z "$part" ] &&  {
  echo "Please specify which part to solve with the env. var. \$part"
  exit 1
}

get_points_part1()
{
  HANDS="$1"
  local TOTAL_POINTS=0

  case "$HANDS" in
    "A X")
      TOTAL_POINTS=$((TOTAL_POINTS + 4)) # rock - rock -> draw
      ;;
    "A Y")
      TOTAL_POINTS=$((TOTAL_POINTS + 8)) # paper - rock -> win
      ;;
    "A Z")
      TOTAL_POINTS=$((TOTAL_POINTS + 3)) # sissor - rock -> loss
      ;;
    "B X")
      TOTAL_POINTS=$((TOTAL_POINTS + 1)) # rock - paper -> loss
      ;;
    "B Y")
      TOTAL_POINTS=$((TOTAL_POINTS + 5)) # paper - paper -> draw
      ;;
    "B Z")
      TOTAL_POINTS=$((TOTAL_POINTS + 9)) # sissor - paper -> win
      ;;
    "C X")
      TOTAL_POINTS=$((TOTAL_POINTS + 7)) # rock - sissor -> win
      ;;
    "C Y")
      TOTAL_POINTS=$((TOTAL_POINTS + 2)) # paper - sissor -> loss
      ;;
    "C Z")
      TOTAL_POINTS=$((TOTAL_POINTS + 6)) # sissor - sissor -> draw
      ;;
  esac
  echo "$TOTAL_POINTS"
}

get_points_part2()
{
  HANDS="$1"
  local TOTAL_POINTS=0

  case "$HANDS" in
    "A X")
      TOTAL_POINTS=$((TOTAL_POINTS + 3)) # rock - rock -> draw
      ;;
    "A Y")
      TOTAL_POINTS=$((TOTAL_POINTS + 4)) # paper - rock -> win
      ;;
    "A Z")
      TOTAL_POINTS=$((TOTAL_POINTS + 8)) # sissor - rock -> loss
      ;;
    "B X")
      TOTAL_POINTS=$((TOTAL_POINTS + 1)) # rock - paper -> loss
      ;;
    "B Y")
      TOTAL_POINTS=$((TOTAL_POINTS + 5)) # paper - paper -> draw
      ;;
    "B Z")
      TOTAL_POINTS=$((TOTAL_POINTS + 9)) # sissor - paper -> win
      ;;
    "C X")
      TOTAL_POINTS=$((TOTAL_POINTS + 2)) # rock - sissor -> win
      ;;
    "C Y")
      TOTAL_POINTS=$((TOTAL_POINTS + 6)) # paper - sissor -> loss
      ;;
    "C Z")
      TOTAL_POINTS=$((TOTAL_POINTS + 7)) # sissor - sissor -> draw
      ;;
  esac
  echo "$TOTAL_POINTS"
}

solve()
{
  TOTAL_POINTS=0

  while read -r line; do

    if [ "$part" = "part1" ]; then
      POINTS=$(get_points_part1 "$line")
    else
      POINTS=$(get_points_part2 "$line")
    fi

    TOTAL_POINTS=$((TOTAL_POINTS + POINTS))

  done < input.txt

  echo "$TOTAL_POINTS"
}

solve
