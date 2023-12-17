#!/bin/bash



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

read -p "Enter a choice (1-8): " choice
case $choice in
    1)
        echo -e "\n"
        dbname=$(./createDB.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "create database"
        
    ;;
    2)
        echo -e "\n"
        dbname=$(./add_table.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "create table"
    ;;
    3)
        echo -e "\n"
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
        dbname=$(./insert_data.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "insert into table"
    ;;
    7)
        echo -e "\n"
        dbname=$(./update_data.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "update data in table"
    ;;    
    8)
        echo -e "\n"
        dbname=$(./delete_data.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "delete data from table"
    ;;
    9)
        echo -e "\n"
        dbname=$(./retrieve_data.sh)
        status="$?"
        ./log.sh "$dbname" "$status" "retrieve data"
    ;;
    *)
        echo -e "\nInvalid input please enter a numvber betwen 1-9\n"
        
    ;;
esac
done