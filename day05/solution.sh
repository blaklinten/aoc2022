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

perform_instruction()
{
  INSTRUCTIONS="$1"
  LOOP=$(cut -d' ' -f2 <<<"$INSTRUCTIONS")
  SOURCE_STACK=$(cut -d' ' -f4 <<<"$INSTRUCTIONS")
  DEST_STACK=$(cut -d' ' -f6 <<<"$INSTRUCTIONS")

  COUNT=0
  while [ "$COUNT" -lt "$LOOP" ]; do
    COUNT=$((COUNT + 1))
    CONTENT_TO_MOVE=$(sed -n 1p stack"$SOURCE_STACK")

    # Push
    printf '%s\n' "$CONTENT_TO_MOVE" > content
    cat content "stack$DEST_STACK" > dest_file
    mv dest_file "stack$DEST_STACK"

    # Pop
    sed -n 2,\$p "stack$SOURCE_STACK" >> source_file
    mv source_file "stack$SOURCE_STACK"
  done
}

print_top_crates()
{
  for stack in stack*; do
    head -n1 "$stack" | tr -d '[:cntrl:]'
  done
}

solve()
{
  while IFS= read -r line; do
    if [ -z "$line" ] || [ "${line:0:3}" = " 1 " ] ; then # Empty line or stack number, ignore
      continue
    elif [ "${line:0:4}" = "move" ]; then # instructions
      perform_instruction "$line"
    else # A stack line
      stack_them_boxes "$line"
    fi
    done<"input.txt"

    print_top_crates
    rm -f stack* content
}

solve
