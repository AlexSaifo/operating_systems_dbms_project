#!/bin/bash

databasesDirectory="../databases"
echo "Enter the name of the database you want to add a table to:">&2
read database

if [ ! -d "$databasesDirectory/$database" ]; then
    echo "Error: Database does not exist.">&2
    echo "$database"
    exit 1
fi

echo "Enter the name of the table you want to add:">&2
read table

echo "Enter the number of columns you want in the table:">&2
read num_columns

columns="id"  # default column
for ((i=1; i<=num_columns; i++))
do
    echo "Enter the name of column $i:">&2
    read column
    columns="$columns,$column"
done

echo "$columns" > "$databasesDirectory/$database/$table.txt"
if [ $? -eq 0 ]; then
    echo "Table $table with columns $columns has been successfully created in the $database database.">&2
    echo "$database"
    exit 0
else
    echo "Error: Failed to create the table.">&2
    echo "$database"
    exit 1
fi

