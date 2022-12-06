#!/bin/bash

[ -z "$part" ] &&  {
  echo "Please specify which part to solve with the env. var. \$part"
  exit 1
}

solve()
{
  INDEX=0

  if [ "$part" = "part1" ]; then
    MARKER_LENGTH=4
  else
    MARKER_LENGTH=14
  fi

  while read -r -n1 char; do
    INDEX=$((INDEX + 1))
    printf '%s\n' "$char" >> sequence

    if [ "$INDEX" -lt "$MARKER_LENGTH" ]; then
      continue
    fi

    if [ "$(sort -u <"sequence" | wc -l)" = "$MARKER_LENGTH" ]; then
      echo "$INDEX"
      rm sequence
      exit
    fi

    sed -n 2,\$p sequence >> tmp_sequence
    mv tmp_sequence sequence
    
  done <input.txt

  echo "$COUNT"
}

solve
