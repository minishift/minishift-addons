#!/usr/bin/env bash

# $1 represents the minishift binary
# $2 represents the addon name
# $3 represents the addon directory

echo "- Testing $2 addon"

echo "Minishift version: $($1 version)"
echo "Minishift status: $($1 status)"
echo "Starting Minishift"

$1 start

echo "Installing $3 addon"
# Install addon
$1 addons install $3

expectedOutput=$(cat <<EOM
-- Applying addon 'cors':..
CORS is now allowed from any address
EOM
)

echo "Applying $3 addon"
# Apply addon
output=$($1 addons apply $2)

echo "Veriying addon apply"
if [ "$?" != 0 ]; then
  echo "Failed to apply $2 addon"
fi

if [ "$output" != "$expectedOutput" ]; then
    printf "Failed to apply $2 addon.\n---- Expected:\n'$expectedOutput'\n---- But got:\n '$output'.\n"
fi

echo "Addon apply successful"