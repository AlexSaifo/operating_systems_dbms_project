#!/bin/bash

databasesDirectory="../databases"



function printDatabase {
    echo "available databases:"
    readarray -t databases <<< "$(ls "$databasesDirectory")"
    for database in "${databases[@]}"; do
    ./check_permissions.sh  "$database" -w
    if [ $? -eq 0 ]; then 
    echo "$database"
    fi
    done
}

function printbackups {
    echo "available databases:"
    readarray -t databases <<< "$(ls "$databasesDirectory")"
    for database in "${databases[@]}"; do
    ./check_permissions.sh  "$database" -w
    if [ $? -eq 0 ] && [ -d "/opt/backups/${database}" ]; then 
    echo "$database"
    fi
    done
}

while true;
do 
echo "available actions"
echo "1- create database"
echo "2- create table"
echo "3- delete table"
echo "4- delete database"
echo "5- empty database"
echo "6- insert data into table"
echo "7- edit data in table"
echo "8- delete data from table"
echo "9- retreive data"
echo "10 - manual backup"
echo "11 - schedule backup"
echo "12 - restore from backup"

read -p "Enter a choice (1-12): " choice
case $choice in
    1)
        echo -e "\n"
        read -p "Enter the name database: " database
        read -p "Is it public (y/n) ?: " ispublic
        if [ "$ispublic" == 'y' ];then
        ./createDB.sh --pu "$database"

        else
        ./createDB.sh "$database"
        fi
        status="$?"
        ./log.sh "$database" "$status" "create database"
        
    ;;
    2)
        echo -e "\n"
        printDatabase
        dbname=$(./add_table.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "create table"
    ;;
    3)
        echo -e "\n"
        printDatabase
        dbname=$(./delete_table.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "delete table"
    ;;
    4)
        echo -e "\n"
        
        dbname=$(./deleteDB.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "delete database"
    ;;
    5)
        echo -e "\n"
        
        dbname=$(./emptyDB.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "empty database"
    ;;
    6)
        echo -e "\n"
        printDatabase
        dbname=$(./insert_data.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "insert into table"
    ;;
    7)
        echo -e "\n"
        printDatabase
        dbname=$(./update_data.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "update data in table"
    ;;    
    8)
        echo -e "\n"
        printDatabase
        dbname=$(./delete_data.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "delete data from table"
    ;;
    9)
        echo -e "\n"
        printDatabase
        dbname=$(./retrieve_data.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "retrieve data"
    ;;
    10)
        echo -e "\n"
        printDatabase
        read -p "Enter the name database: " database
        echo "backup types: --tar --gzip --zip: "
        read -p "enter the name of the backup type: " backupType
        ./backup.sh -m $backupType $database
        status="$?"
        ./log.sh "$database" "$status" "manual backup"
    ;;
    11)
        echo -e "\n"
        printDatabase
        read -p "Enter the name database: " database
        echo "backup types: --tar --gzip --zip: "
        read -p "enter the name of the backup type: " backupType
        read -p "enter backup frequency 1m 10m 1h 1d 1M: " frequency
        ./backup.sh -s $backupType $database $frequency
        status="$?"
        ./log.sh "$database" "$status" "schedule $frequency backup"
    ;;
        12)
        echo -e "\n"
        printbackups
        dbname=$(./restore.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "restore database"
    ;;
    *)
        echo -e "\nInvalid input please enter a number betwen 1-9\n"
        printDatabase
    ;;
esac
done
