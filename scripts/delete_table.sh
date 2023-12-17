#!/bin/bash

databasesDirectory="../databases"

echo "Databases:">&2
ls $databasesDirectory>&2
echo "Enter the name of the database you want to delete a table from:">&2
read database

if [ ! -d "$databasesDirectory/$database" ]; then
    echo "Error: Database does not exist.">&2
    echo "$database"
    exit 1
fi

echo "Tables:">&2
ls "$databasesDirectory/$database">&2
echo "Enter the name of the table you want to delete:">&2
read table

if [ ! -f "$databasesDirectory/$database/$table.txt" ]; then
    echo "Error: Table does not exist.">&2
    echo "$database"
    exit 1
fi

yes | rm "$databasesDirectory/$database/$table.txt"
if [ $? -eq 0 ]; then
    echo "Table $table has been successfully deleted from the $database database.">&2
    echo "$database"
    exit 0
else
    echo "Error: Failed to delete the table.">&2
    echo "$database"
    exit 1
fi
