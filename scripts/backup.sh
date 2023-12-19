#!/bin/bash

backupsPath="/opt/backups" 
fileName="backup-$(date +"H-%H-M-%M-S-%S-%Y-%m-%d")"

databaseName=$3

function makeDir {
    if [ ! -d "$backupsPath/$databaseName" ]; then
    mkdir -p "$backupsPath/$databaseName"
    
    
 
    fi
}

function tarZip {
    #tar
    makeDir
    tar -cvf $( realpath "$backupsPath/$databaseName/$databaseName-$fileName.tar" )  "../databases/$databaseName/" 
    check_storage "$backupsPath/$databaseName/$databaseName-$fileName.tar"

}

function gzip {
    # gzip
    makeDir
    tar -czvf $( realpath "$backupsPath/$databaseName/$databaseName-$fileName.gz" )  "../databases/$databaseName/"
    check_storage "$backupsPath/$databaseName/$databaseName-$fileName.gz"

}

function zipZip {
    makeDir
    zip $( realpath "$backupsPath/$databaseName/$databaseName-$fileName.zip") "../databases/$databaseName"
    check_storage "$backupsPath/$databaseName/$databaseName-$fileName.zip"
    exit 0
}

function check_storage {
sz_limit=20  

file_path=$1
current_sz=$(du -k "$file_path" | cut -f1) 
if [ "$current_sz" -gt "$sz_limit" ];then
rm "$file_path"
exit 1
fi
while true; do
    folder_sz=$(du -k "$backupsPath/$databaseName" | cut -f1)
    echo "folder size: $folder_sz"
    total_limit=$((sz_limit + current_sz))
    echo "total_limit: $total_limit"
    if [ "$folder_sz" -gt "$sz_limit" ]; then
        readarray -t backupFiles <<< "$( ls -t $( realpath "$backupsPath/$databaseName" ))"
        oldest_file="${backupFiles[-1]}"
        rm "$backupsPath/$databaseName/$oldest_file"
        echo "Deleted: $folder/$oldest_file"
    else
        echo "Moved: current to $folder/"
        exit 0
    fi
done    
}

if [ $1 == "-h" ]; then
    echo "Usage $0 [OPTIONS] [DATABASE_NAME]"
    echo "-"
    
    exit 0
fi


if [ $1 == "-m" ]; then
      
    if [ $2 == "--tar" ]; then
        tarZip
    elif [ $2 == "--zip" ]; then
        zipZip
    elif [ $2 == "--gzip" ];then
        gzip
    fi

    max_backups=5

    readarray -t databases <<< "$( ls -t $( realpath "$backupsPath/$databaseName" ))"
    for ((i = max_backups; i < ${#databases[@]}; i++)); do
     if [ "$i" -ge $max_backups ]; then
        rm "$backupsPath/$databaseName/${databases[i]}"
        echo "Removed: $backupsPath/$databaseName/${databases[i]}"
    fi
    done

    exit 0;
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