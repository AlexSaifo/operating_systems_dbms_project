#!/bin/bash

backupsPath="/opt/backups" 
fileName="backup-$(date +"%Y-%m-%d")"

databaseName=""

function tarZip {
    #tar
    tar -cvf $( realpath "$backupsPath/$3-$fileName.tar" )  "../databases/$3/" 
}

function gzip {
    # gzip
    tar -czvf $( realpath "$backupsPath/$3-$fileName.gz" )  "../databases/$3/"
}

function zipZip {
   # zip
#    echo "~/../..$backupsPath/$databaseName-$fileName.zip"
    zip $( realpath "$backupsPath/$3-$fileName.zip") "../databases/$3"
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
fi

HOUR=$( date +"%H" )
DAY=$( date +"%d" )
MONTH=$( date +"%m" )
directory=$( pwd )

if [ $1 == "-s" ]; then
 # prompt user to enter backup frequency( hourly, daily, monthly, yearly, every 5 minutes)
 echo "Enter backup frequency (hourly, daily, monthly, yearly, every 5 minutes):"
 read frequency
 # also add default option if user does not specify second argument 
if [ $2 == "--tar" ]; then
   # add cron job to schedule tar backup
   if [ $frequency == "hourly" ]; then
       "0 * * * * $PWD/backup.sh -m --tar $databaseName" | crontab -
   elif [ $frequency == "daily" ]; then
       "0 $HOUR * * * $PWD/backup.sh -m --tar $databaseName" | crontab -
   elif [ $frequency == "monthly" ]; then
       "0 $HOUR $DAY * * $PWD/backup.sh -m --tar $databaseName" | crontab -
   elif [ $frequency == "yearly" ]; then
       "0 $HOUR $DAY $MONTH * $PWD/backup.sh -m --tar $databaseName" | crontab -
   elif [ $frequency == "every 5 minutes" ]; then
       "*/5 * * * * $PWD/backup.sh -m --tar $databaseName" | crontab -
   fi
fi
fi
