#!/bin/bash

help="Usage createDB [OPTION] DATABASE_NAME"
type="private"


case "$1" in
    --pu)
        shift 1
        type="public"
    ;;
    --pr)
        shift 1
        type="private"
    ;;
    -h)
        echo $help
        exit
    ;;
    --*) 
        echo "Invalid option"
        exit 1
esac

database_name=$1

set -e

if [ -z "$database_name" ]; then
    echo "Invalid database name">&2
    echo "$database_name"
    exit 1
fi

databases_path="../databases/"
database_path="${databases_path}${database_name}"

find_output=$(  find  $databases_path -type d -name $database_name)

if [ -n "$find_output" ]; then
    echo "the database \"$database_name\" already exists!">&2
    echo "$database_name"
    exit 1
    
fi


 mkdir -p $database_path

 groupadd "$database_name"
 usermod -aG "$database_name" "$(whoami)"
 chgrp "$database_name" "$database_path"

 chmod 770 "$database_path"

admins_file="../admins/admins.txt"

while IFS= read -r username
do
     usermod -a -G "$database_name" "$username"
done < $admins_file

if [ "$type" = "public" ]; then
    chmod 777 "$database_path"
fi
echo "$database_name"
exit 0

