#!/bin/bash

[ -z "$part" ] &&  {
  echo "Please specify which part to solve with the env. var. \$part"
  exit 1
}

ROOT="$PWD"
WD="$ROOT/aoc-base-dir"
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

aoc_mkdir()
{
  DIR_NAME="$1"
  mkdir "$DIR_NAME"
  touch "$DIR_NAME/dir_size"
}

sum()
{
  sum=0
  while read -r size; do
    sum=$((sum + size))
  done
  printf '%s' "$sum"
}

create_file_with_size()
{
  local FILE_NAME="$1"
  local FILE_SIZE"$2"

  echo "$FILE_SIZE" > "$FILE_NAME"
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

find_sum_of_dir_less_than_100000()
{
  TOTAL=0
  while read -r line; do
    SIZE="$(cut -d',' -f 1 <<<"$line")"
    if [ "$SIZE" -lt 100000 ]; then
      TOTAL=$((TOTAL + SIZE))
    fi
  done <<<"$( sort -n "$TMP_SUM")"
  echo "$TOTAL"
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
      aoc_mkdir "${line:4}"
    else # File is found, create it
      FILE_NAME="$(cut -d' ' -f2 <<<"$line")"
      FILE_SIZE="$(cut -d' ' -f1 <<<"$line")" 
      create_file_with_size "$FILE_NAME" "$FILE_SIZE"
    fi
  done<"input.txt"

  calculate_dir_sizes

  find_sum_of_dir_less_than_100000
}

solve
