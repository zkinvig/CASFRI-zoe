#!/bin/bash -x

source ../../config.sh

bashCmd="/c/program files/git/git-bash.exe"

# Make the process wait for the first load to finish before resuming to let PostgreSQL create the schema
# Wait also after the last from the first list to avoid overloading the system
for F in "${photoYearList[@]}"
do
  if [ $F == ${photoYearList} ] || [ $F == ${photoYearList[-1]} ]; then
    "$bashCmd" load_${F,,}.sh /dev/null
  else
    "$bashCmd" load_${F,,}.sh & /dev/null
  fi
done

declare -n L

# Iterate over the list of list always making the last command a waiting one (the following ones wait for it to finish before proceeding)
for L in "${fullList[@]}"; do
  for F in "${L[@]}"; do
    if [ $F == ${L[-1]} ]; then
      "$bashCmd" load_${F,,}.sh /dev/null
    else
      "$bashCmd" load_${F,,}.sh & /dev/null
    fi
  done
done

