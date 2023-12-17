#!/bin/bash

backupsPath="/opt/backups" 
fileName="backup-$(date +"%Y-%m-%d")"

if [ $1 == "-h" ]; then
    echo "Usage $0 [OPTIONS] [DATABASE_NAME]"
    echo "-"
    
    exit 0
fi

# echo $backupsPath 'fuck me'

zip -r $( realpath "$backupsPath/$fileName.zip" )  ../databases/

# tar
tar -cvf $( realpath "$backupsPath/$fileName.tar" )  ../databases

# gzip
tar -czvf $( realpath "$backupsPath/$fileName.gz" )  ../databases
