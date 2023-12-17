#!/bin/bash

databasesDirectory="../databases"

echo "Databases:"
ls $databasesDirectory
echo "Enter the name of the database you want to delete a table from:"
read database

if [ ! -d "$databasesDirectory/$database" ]; then
    echo "Error: Database does not exist."
    exit 1
fi

echo "Tables:"
ls "$databasesDirectory/$database"
echo "Enter the name of the table you want to delete:"
read table

if [ ! -f "$databasesDirectory/$database/$table.txt" ]; then
    echo "Error: Table does not exist."
    exit 1
fi

rm "$databasesDirectory/$database/$table.txt"
if [ $? -eq 0 ]; then
    echo "Table $table has been successfully deleted from the $database database."
else
    echo "Error: Failed to delete the table."
    exit 1
fi
