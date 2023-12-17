#!/bin/bash

databasesDirectory="../databases"
echo "Enter the name of the database you want to add a table to:"
read database

if [ ! -d "$databasesDirectory/$database" ]; then
    echo "Error: Database does not exist."
    exit 1
fi

echo "Enter the name of the table you want to add:"
read table

echo "Enter the number of columns you want in the table:"
read num_columns

columns="id"  # default column
for ((i=1; i<=num_columns; i++))
do
    echo "Enter the name of column $i:"
    read column
    columns="$columns,$column"
done

echo "$columns" > "$databasesDirectory/$database/$table.txt"
if [ $? -eq 0 ]; then
    echo "Table $table with columns $columns has been successfully created in the $database database."
else
    echo "Error: Failed to create the table."
    exit 1
fi

