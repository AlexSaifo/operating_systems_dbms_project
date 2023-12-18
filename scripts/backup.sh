#!/bin/bash

backupsPath="/opt/backups" 
fileName="backup-$(date +"H-%H-M-%M-S-%S-%Y-%m-%d")"

databaseName=$3

function makeDir {
    if [ ! -d "$backupsPath/$databaseName" ]; then
    # If the directory doesn't exist, create it
    mkdir -p "$backupsPath/$databaseName"
    
    
 
    fi
}

function tarZip {
    #tar
    makeDir
    tar -cvf $( realpath "$backupsPath/$databaseName/$databaseName-$fileName.tar" )  "../databases/$databaseName/" 
}

function gzip {
    # gzip
    makeDir
    tar -czvf $( realpath "$backupsPath/$databaseName/$databaseName-$fileName.gz" )  "../databases/$databaseName/"
}

function zipZip {
   # zip
#    echo "~/../..$backupsPath/$databaseName-$fileName.zip"
    makeDir
    zip $( realpath "$backupsPath/$databaseName/$databaseName-$fileName.zip") "../databases/$databaseName"
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
    
    # also add default option if user does not specify second argument    
    if [ $2 == "--tar" ]; then
        tarZip
    elif [ $2 == "--zip" ]; then
        zipZip
    elif [ $2 == "--gzip" ];then
        gzip
    fi
    exit 0;

    # keep only newest 5 backups of database
    readarray -t databases <<< "$(ls -t "$databasesDirectory/$databaseName")"


    # if exceeding size DELETE old backups

fi


directory=$( pwd )

if [[ $1 == "-s" ]]; then

  frequency=$4
if [[ $frequency == "1m" ]]; then
    schedule="*/1 * * * *"
  elif [[ $frequency == "10m" ]]; then
    schedule="*/10 * * * *"
  elif [[ $frequency == "1h" ]]; then  
    schedule="0 * * * *"
  elif [[ $frequency == "1d" ]]; then
    schedule="0 0 * * *" 
  elif [[ $frequency == "1M" ]]; then
    schedule="0 0 1 * *"
  else
    echo "Invalid frequency"
    help
  fi

  backupType=$2

  if [[ $backupType ]]; then
    crontab -l | { cat; echo "$schedule bash $directory/backup.sh -m $backupType $databaseName"; } | crontab -
  else 
    echo "Invalid backup type"
    help
  fi

fi