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

read -p "Enter a choice (1-9): " choice
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
        printDatabase
        dbname=$(./deleteDB.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "delete database"
    ;;
    5)
        echo -e "\n"
        printDatabase
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
    *)
        echo -e "\nInvalid input please enter a number betwen 1-9\n"
        printDatabase
    ;;
esac
done
