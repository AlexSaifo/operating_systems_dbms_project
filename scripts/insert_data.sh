#!/bin/bash

databasesDirectory="../databases"

echo "Databases:">&2
ls $databasesDirectory>&2
echo "Enter the name of the database you want to insert data into:">&2
read database

if [ ! -d "$databasesDirectory/$database" ]; then
    echo "Error: Database does not exist.">&2
    echo "$database"
    exit 1
fi

echo "Tables:">&2
ls "$databasesDirectory/$database">&2
echo "Enter the name of the table you want to insert data into:">&2
read table

if [ ! -f "$databasesDirectory/$database/$table.txt" ]; then
    echo "Error: Table does not exist.">&2
    echo "$database"
    exit 1
fi

IFS=',' read -r -a columns <<< "$(head -n 1 "$databasesDirectory/$database/$table.txt")"
data=""
for column in "${columns[@]}"; do
   echo "Enter data for $column:">&2

    read value

   # if this is the first column in columns:
   if [ "$column" == "${columns[0]}" ]; then
       # check that the value entered by the user for the first or (id) column is unique
       ./check_value.sh $database $table id $value
       if [ $? -eq 0 ]; then
           echo "Error: id already exists.">&2
           echo "$database"
           exit 1
       fi
   fi
   # end of id condition

   
   data="$data,$value"
done
data=${data:1} # remove the leading comma

echo "$data" >> "$databasesDirectory/$database/$table.txt"
echo "Data has been successfully inserted into the $table table in the $database database.">&2
echo "$database"
exit 0
