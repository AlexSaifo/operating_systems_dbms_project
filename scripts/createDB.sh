#!/bin/bash

help="Usage createDB [OPTION] DATABASE_NAME"
type="private"


# Process the input options
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
    --*) #invalid option
        echo "Invalid option"
        exit 1
esac

database_name=$1

set -e
# check the database name

if [ -z "$database_name" ]; then
    echo "Invalid database name">&2
    echo "$database_name"
    exit 1
fi

databases_path="../databases/"
database_path="${databases_path}${database_name}"

#check if the folder already exists
find_output=$( sudo find  $databases_path -type d -name $database_name)

if [ -n "$find_output" ]; then
    echo "the database \"$database_name\" already exists!">&2
    echo "$database_name"
    exit 1
    
fi


mkdir -p $database_path

# create a group and add the current user to it
sudo groupadd "$database_name"
sudo usermod -aG "$database_name" "$(whoami)"
sudo chgrp "$database_name" "$database_path"

sudo chmod 770 "$database_path"


# add users in "admins.txt" into the group
admins_file="../admins/admins.txt"

while IFS= read -r username
do
    sudo usermod -a -G "$database_name" "$username"
done < $admins_file

# if it's public then all users have access and can
# perform (retrieve, insert, update) on the database
if [ "$type" = "public" ]; then
    chmod 777 "$database_path"
fi
echo "$database_name"
exit 0

