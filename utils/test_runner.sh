#!/usr/bin/env bash

# $1 represents minishift binary present at build/bin/minishift
# $2 represents the directory containing all test files
# $3 represents the addon dir
# $4 is optional and represent addon name if user want to only run test for single addon

if [ "$4" = "all" ]; then
    for test in "$2"/*; do
      echo "---------"
      addon_name=$(echo "$test" | cut -d'/' -f7 | sed -e "s/test_//g;s/.sh//g")
      $test $1 $addon_name "$3/$addon_name"
    done
else
    $2/test_$4.sh $1 $4 "$3/$4"
fi
