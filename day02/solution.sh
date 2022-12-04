#!/bin/bash

[ -z "$part" ] &&  {
  echo "Please specify which part to solve with the env. var. \$part"
  exit 1
}

part1()
{
  local TOTAL_POINT
  TOTAL_POINT=0

  while read -r line; do
    local OPPONENT
    local SUGGESTED
    OPPONENT=$(cut -d ' ' -f1 <<<"$line")
    SUGGESTED=$(cut -d ' ' -f2 <<<"$line")

    case "$SUGGESTED" in
      "X")
        TOTAL_POINT=$((TOTAL_POINT + 1)) # rock
        case "$OPPONENT" in
          "A")
            TOTAL_POINT=$((TOTAL_POINT + 3)) # rock, a draw :|
          ;;
          "B")
            TOTAL_POINT=$((TOTAL_POINT + 0)) # paper, a lose :(
          ;;
          "C")
            TOTAL_POINT=$((TOTAL_POINT + 6)) # sissor, a win! :)
          ;;
      esac
      ;;
      "Y")
        TOTAL_POINT=$((TOTAL_POINT + 2)) # paper
        case "$OPPONENT" in
          "A")
            TOTAL_POINT=$((TOTAL_POINT + 6)) # rock, a win :)
          ;;
          "B")
            TOTAL_POINT=$((TOTAL_POINT + 3)) # paper, a draw :|
          ;;
          "C")
            TOTAL_POINT=$((TOTAL_POINT + 0)) # sissor, a lose! :(
          ;;
      esac
      ;;
      "Z")
        TOTAL_POINT=$((TOTAL_POINT + 3)) # sissors
        case "$OPPONENT" in
          "A")
            TOTAL_POINT=$((TOTAL_POINT + 0)) # rock, a lose :(
          ;;
          "B")
            TOTAL_POINT=$((TOTAL_POINT + 6)) # paper, a win :)
          ;;
          "C")
            TOTAL_POINT=$((TOTAL_POINT + 3)) # sissor, a draw :|
          ;;
      esac
      ;;
    esac

  done < input.txt

  echo "$TOTAL_POINT"
}

part2()
{
  local TOTAL_POINT
  TOTAL_POINT=0

  while read -r line; do
    local OPPONENT
    local SUGGESTED
    OPPONENT=$(cut -d ' ' -f1 <<<"$line")
    SUGGESTED=$(cut -d ' ' -f2 <<<"$line")

    case "$SUGGESTED" in
      "X")
        TOTAL_POINT=$((TOTAL_POINT + 0)) # lose
        case "$OPPONENT" in
          "A")
            TOTAL_POINT=$((TOTAL_POINT + 3)) # rock -> sissors
          ;;
          "B")
            TOTAL_POINT=$((TOTAL_POINT + 1)) # paper -> rock
          ;;
          "C")
            TOTAL_POINT=$((TOTAL_POINT + 2)) # sissors -> paper
          ;;
      esac
      ;;
      "Y")
        TOTAL_POINT=$((TOTAL_POINT + 3)) #  draw
        case "$OPPONENT" in
          "A")
            TOTAL_POINT=$((TOTAL_POINT + 1)) # rock -> rock
          ;;
          "B")
            TOTAL_POINT=$((TOTAL_POINT + 2)) # paper -> paper
          ;;
          "C")
            TOTAL_POINT=$((TOTAL_POINT + 3)) # sissors -> sissors
          ;;
      esac
      ;;
      "Z")
        TOTAL_POINT=$((TOTAL_POINT + 6)) # win
        case "$OPPONENT" in
          "A")
            TOTAL_POINT=$((TOTAL_POINT + 2)) # rock -> paper
          ;;
          "B")
            TOTAL_POINT=$((TOTAL_POINT + 3)) # paper -> sissors
          ;;
          "C")
            TOTAL_POINT=$((TOTAL_POINT + 1)) # sissor -> rock
          ;;
      esac
      ;;
    esac

  done < input.txt

  echo "$TOTAL_POINT"
}

main()
{
  if [ "$part" = "part1" ]; then
    part1
  else
    part2
  fi
}

main
