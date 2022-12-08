#!/bin/bash

[ -z "$part" ] &&  {
  echo "Please specify which part to solve with the env. var. \$part"
  exit 1
}

ROOT="$PWD"
WD="$ROOT/day07-base-dir"
TMP_SUM="$ROOT/sum"

aoc_cd()
{
  DIR_NAME="$1"
  if [ "$DIR_NAME" == "/" ]; then
    builtin cd "$WD" || exit
  else
    builtin cd "$*/" || exit
  fi
}

sum()
{
  sum=0
  while read -r size; do
    sum=$((sum + size))
  done
  printf '%s' "$sum"
}

calculate_dir_sizes()
{
  cd "$WD" || exit
  while IFS= read -r dir; do
    pushd "$dir" > /dev/null || exit
    find . -type f ! -name "sum" -exec cat {} \; | sum >> "$TMP_SUM"
    printf ',%s\n' "$dir" >> "$TMP_SUM"
    popd > /dev/null || exit
  done < <(find . -type d)
}

find_sum_of_dirs_less_than_100000()
{
  TOTAL=0
  while read -r line; do
    SIZE="$(cut -d',' -f 1 <<<"$line")"
    if [ "$SIZE" -lt 100000 ]; then
      TOTAL=$((TOTAL + SIZE))
    fi
  done <<<"$(sort -n "$TMP_SUM")"
  echo "$TOTAL"
}

free_up_just_enough_space()
{
  DISK_SIZE="70000000"
  SPACE_NEEDED="30000000"
  CURRENTLY_USED_SPACE_AT_ROOT="$(sort -n "$TMP_SUM" | tail -n1 )"
  CURRENTLY_USED_SPACE="$(cut -d',' -f1 <<<"$CURRENTLY_USED_SPACE_AT_ROOT")"
  CURRENTLY_FREE_SPACE="$((DISK_SIZE - CURRENTLY_USED_SPACE))"
  SPACE_DIFF="$((SPACE_NEEDED - CURRENTLY_FREE_SPACE))"

  while read -r size_and_dir; do
    local SIZE
    SIZE="$(cut -d',' -f1 <<<"$size_and_dir")"
    if [ "$SIZE" -lt "$SPACE_DIFF" ]; then
      continue
    else
      echo "$SIZE"
      return
    fi
  done < <(sort -n "$TMP_SUM")
}

solve()
{
  mkdir "$WD"

  while read -r line; do
    if [ "${line:0:4}" = "$ cd" ] ; then # cd, try to execute
      aoc_cd "${line:5}"
    elif [ "${line:0:4}" = "$ ls" ] ; then # cd, try to execute
      continue
    elif [ "${line:0:3}" = "dir" ]; then # Directory is found, create it
      mkdir "${line:4}"
    else # File is found, create it
      FILE_NAME="$(cut -d' ' -f2 <<<"$line")"
      FILE_SIZE="$(cut -d' ' -f1 <<<"$line")" 
      echo "$FILE_SIZE" > "$FILE_NAME"
    fi
  done<"input.txt"

  calculate_dir_sizes

  if [ "$part" = "part1" ]; then
    find_sum_of_dirs_less_than_100000
  else
    free_up_just_enough_space
  fi

  rm -r "$TMP_SUM" "$WD"
}

solve
