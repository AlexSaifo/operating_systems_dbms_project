#!/bin/bash

backupsPath="/opt/backups" 
read -p "Enter the database name: " databaseName
if [ -z $databaseName ]; then
    echo "invalid database name: $databaseName">2&
    echo "null"
    exit 1
fi

echo "Backups: ">&2
echo $(ls "$(realpath ${backupsPath}/${databaseName})/")>&2
echo "$(realpath ${backupsPath}/${databaseName})/"
read -p "Enter the name of the backup to restore: " dbname

if [ ! -f "${backupsPath}/${databaseName}/${dbname}" ];then
    echo "invalid ">&2
    echo $databaseName
    exist 1
fi
rm -r "../databases/${databaseName}" 2> /dev/null


file="${backupsPath}/${databaseName}/${dbname}"
case $file in
 *.tar.gz) tar -xzf "$file" -C "../" ;;
 *.tar) tar -xf "$file" -C "../" ;;
 *.zip) unzip "$file" -d "../" ;;
esac
echo "database $file" restored successfully
