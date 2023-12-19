#!/bin/bash

databasesDirectory="../databases"

database_name=$1

if [[ ! -d "$databasesDirectory/$database_name" ]]; then
echo "undefined"
exit 1
fi

directory_owner=$(stat -c '%U' "$databasesDirectory/$database_name")

current_user=$(whoami)

if [ "$current_user" = "$directory_owner" ]; then
    echo "owner"
    exit 0
else
  while IFS= read -r line
  do
    if [ "$line" == $current_user ];then
    echo "admin"
    exit 0
    fi
  done < "../admins/admins.txt"
  echo "other"
fi