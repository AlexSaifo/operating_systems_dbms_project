#!/bin/bash
dir="databases"

# Loop over all directories in the databases folder
find ${dir} -mindepth 1 -maxdepth 1 -type d -exec bash -c '
 folder="{}";
 # Check if the current user is the owner of the directory and can delete the directory
 if [ "$(stat -c %U ${folder})" = "$(whoami)" ] && test -w ${folder}
 then
     # Check if the directory is empty
     if [ ! -z "$(ls -A ${folder})" ];
     then
         # Print the name of the directory
         echo ${folder}
     fi
 fi
' \;

read -p "Enter database's name to be deleted: databases/" database_name

# Check if the directory exists and if the user has write permissions to it
if [ ! -d "databases/${database_name}" ] || [ ! -w "databases/${database_name}" ]|| [ -z $database_name ]
then
 echo "Invalid Database name"
 exit 1
fi

# Check if the directory is empty
if [ -z "$(ls -A "databases/${database_name}")" ];
then
 echo "database is empty"
 exit 1
fi

# Delete the contents of the directory
rm -r "databases/${database_name}"/*

echo "database ${database_name} now is empty."