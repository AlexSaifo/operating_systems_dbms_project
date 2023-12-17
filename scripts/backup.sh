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

function zipZip {
   # zip
#    echo "~/../..$backupsPath/$databaseName-$fileName.zip"
    zip $( realpath "$backupsPath/$databaseName-$fileName.zip") "../databases/$databaseName"
    exit 0
}


# show help for usage
if [ $1 == "-h" ]; then
    echo "Usage $0 [OPTIONS] [DATABASE_NAME]"
    echo "-"
    
    exit 0
fi


# user want to do manual backup
if [ $1 == "-m" ]; then
    echo "enter database name to backup"
    read databaseName
    # also add default option if user does not specify second argument    
    if [ $2 == "--tar" ]; then
        tarZip
    elif [ $2 == "--zip" ]; then
        zipZip
    elif [ $2 == "--gzip" ];then
        gzip
    fi
    exit 0;
fi

