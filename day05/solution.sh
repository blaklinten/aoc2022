#!/bin/bash

[ -z "$part" ] &&  {
  echo "Please specify which part to solve with the env. var. \$part"
  exit 1
}

stack_them_boxes()
{
  STACKS="$1"
  COUNT=0
  STACK_COUNT=1
  BOX=""
  while IFS= read -r -n1 char; do
    COUNT=$((COUNT + 1))
    BOX=$BOX$char
    if [ "$COUNT" = 3 ]; then
      if [ "$BOX" = "   " ]; then # No box in this stack at this height, ignore
        continue
      fi

      echo "${BOX:1:1}" >> stack"$STACK_COUNT"
    fi

    if [ "$COUNT" = 4 ]; then
      COUNT=0
      STACK_COUNT=$((STACK_COUNT + 1))
      BOX=""
    fi
  done<<<"$STACKS"
}

perform_instructions()
{
  INSTRUCTIONS="$1"

  if [ "$part" = "part1" ]; then
    LOOP=$(cut -d' ' -f2 <<<"$INSTRUCTIONS")
    NUMBER_OF_CRATES_TO_MOVE=1
  else
    LOOP=1
    NUMBER_OF_CRATES_TO_MOVE=$(cut -d' ' -f2 <<<"$INSTRUCTIONS")
  fi

  SOURCE_STACK=$(cut -d' ' -f4 <<<"$INSTRUCTIONS")
  DEST_STACK=$(cut -d' ' -f6 <<<"$INSTRUCTIONS")

  COUNT=0
  while [ "$COUNT" -lt "$LOOP" ]; do
    COUNT=$((COUNT + 1))

    # Push
    sed -n 1,"$NUMBER_OF_CRATES_TO_MOVE"p stack"$SOURCE_STACK" > content
    cat content "stack$DEST_STACK" > dest_file
    mv dest_file "stack$DEST_STACK"

    # Pop
    sed -n "$((NUMBER_OF_CRATES_TO_MOVE + 1))",\$p "stack$SOURCE_STACK" >> source_file
    mv source_file "stack$SOURCE_STACK"
  done
}

print_top_crates()
{
  for stack in stack*; do
    head -n1 "$stack" | tr -d '[:cntrl:]'
  done
  echo
}

solve()
{
  while IFS= read -r line; do
    if [ -z "$line" ] || [ "${line:0:3}" = " 1 " ] ; then # Empty line or stack number, ignore
      continue
    elif [ "${line:0:4}" = "move" ]; then # instructions
      perform_instructions "$line"
    else # A stack line
      stack_them_boxes "$line"
    fi
    done<"input.txt"

    print_top_crates
    rm -f stack* content
}

solve
