#!/bin/bash

backupsPath="/opt/backups" 
fileName="backup-$(date +"%Y-%m-%d")"

databaseName=""

function tarZip {
    #tar
    tar -cvf $( realpath "$backupsPath/$databaseName-$fileName.tar" )  "../databases/$databaseName/" 
}

function gzip {
    # gzip
    tar -czvf $( realpath "$backupsPath/$databaseName-$fileName.gz" )  "../databases/$databaseName/"
}

function zip {
    # zip
    zip -r $( realpath "$backupsPath/$databaseName-$fileName.zip" )  "../databases/$databaseName/"
}

# show help for usage
if [ $1 == "-h" ]; then
    echo "Usage $0 [OPTIONS] [DATABASE_NAME]"
    echo "-"
    
    exit 0
fi

echo "enter database name to backup"
    read databaseName

# user want to do manual backup
if [ $1 == "-m" ]; then
    
    if [ $2 == "--tar"]; then
        tarZip
    if [ $2 == "--zip" ]
        zip
    if [ $3 == "--gzip"]
        gzip
fi

