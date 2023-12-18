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
    check_storage "$backupsPath/$databaseName/$databaseName-$fileName.tar"

}

function gzip {
    # gzip
    makeDir
    tar -czvf $( realpath "$backupsPath/$databaseName/$databaseName-$fileName.gz" )  "../databases/$databaseName/"
    check_storage "$backupsPath/$databaseName/$databaseName-$fileName.gz"

}

function zipZip {
   # zip
#    echo "~/../..$backupsPath/$databaseName-$fileName.zip"
    makeDir
    zip $( realpath "$backupsPath/$databaseName/$databaseName-$fileName.zip") "../databases/$databaseName"
    check_storage "$backupsPath/$databaseName/$databaseName-$fileName.zip"
    exit 0
}

function check_storage {
sz_limit=20  # replace with the desired size limit in megabytes

file_path=$1
current_sz=$(du -k "$file_path" | cut -f1) # replace with the size of the "current" file in megabytes
if [ "$current_sz" -gt "$sz_limit" ];then
rm "$file_path"
exit 0
fi
while true; do
    # Get the current size of the folder
    folder_sz=$(du -k "$backupsPath/$databaseName" | cut -f1)
    echo "folder size: $folder_sz"
    # Calculate the total limit
    total_limit=$((sz_limit + current_sz))
    echo "total_limit: $total_limit"
    # Check if the folder size is greater than the limit
    if [ "$folder_sz" -gt "$sz_limit" ]; then
        # Delete the oldest file in the folder
        readarray -t backupFiles <<< "$( ls -t $( realpath "$backupsPath/$databaseName" ))"
        oldest_file="${backupFiles[-1]}"
        rm "$backupsPath/$databaseName/$oldest_file"
        echo "Deleted: $folder/$oldest_file"
    else
        # Move the "current" file into the folder
        #mv "current" "$backupsPath/$databaseName/"
        echo "Moved: current to $folder/"
        exit 0
    fi
done    
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

    max_backups=5

    # keep only newest 5 backups of database
    readarray -t databases <<< "$( ls -t $( realpath "$backupsPath/$databaseName" ))"
    for ((i = max_backups; i < ${#databases[@]}; i++)); do
     if [ "$i" -ge $max_backups ]; then
        rm "$backupsPath/$databaseName/${databases[i]}"
        echo "Removed: $backupsPath/$databaseName/${databases[i]}"
    fi
    done
    # if exceeding size DELETE old backups

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