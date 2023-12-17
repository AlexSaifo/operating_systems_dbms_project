#!/bin/bash
databasesDirectory="./databases"
# echo "Enter the name of the database:"
database=$1
# echo "Enter the name of the table:"
table=$2
# echo "Enter the name of the column:"
column=$3
# echo "Enter the value to search for:"
value=$4

# check all arguments exist
if [ -z "$database" ] || [ -z "$table" ] || [ -z "$column" ] || [ -z "$value" ]; then
   echo "Error: Not all arguments supplied."
   exit 1
fi


if [ ! -d "$databasesDirectory/$database" ] || [ ! -f "$databasesDirectory/$database/$table.txt" ]; then
#    echo "Error: Database or table does not exist."
   exit 1
fi
IFS=',' read -r -a columns <<< "$(head -n 1 "$databasesDirectory/$database/$table.txt")"
column_index=-1
for ((i=0; i<${#columns[@]}; i++)); do
   if [ "${columns[i]}" = "$column" ]; then
       column_index=$i
       break
   fi
done
if [ $column_index -eq -1 ]; then
#    echo "Error: Column does not exist."
   exit 1
fi
while IFS=',' read -r -a row
do
   if [ "${row[column_index]}" = "$value" ]; then
    #    echo "Value exists in the $column column of the $table table in the $database database."
       exit 0
   fi
done < <(tail -n +2 "$databasesDirectory/$database/$table.txt")

# echo "Value does not exist in the $column column of the $table table in the $database database."
exit 1

