#!/bin/bash

[ -z "$part" ] &&  {
  echo "Please specify which part to solve with the env. var. \$part"
  exit 1
}

calculate_elf_calories()
{
  local ELF_INDEX=0
  local ELF_SUM=0
  while read -r line; do
    if [ -z "$line" ]; then
      printf '%s\n' "$ELF_SUM" >> calories
      ELF_INDEX=$((ELF_INDEX + 1))
      ELF_SUM=0
    else
      ELF_SUM=$((ELF_SUM + line))
    fi
  done < input.txt
}

sum()
{
  sum=0
  while read -r calorie; do
    sum=$((sum + calorie))
  done
  echo "$sum"
}

solve()
{
  calculate_elf_calories
  if [ "$part" = "part1" ]; then
    sort -n calories | tail -n1
  else
    sort -n calories | tail -n3 | sum
  fi
  rm -f calories
}

solve
