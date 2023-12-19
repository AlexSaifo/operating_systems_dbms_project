#!/bin/bash
databasesDirectory="../databases"
database=$1
table=$2
column=$3
value=$4

if [ -z "$database" ] || [ -z "$table" ] || [ -z "$column" ] || [ -z "$value" ]; then
   echo "Error: Not all arguments supplied."
   exit 1
fi


if [ ! -d "$databasesDirectory/$database" ] || [ ! -f "$databasesDirectory/$database/$table.txt" ]; then
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
   exit 1
fi
while IFS=',' read -r -a row
do
   if [ "${row[column_index]}" = "$value" ]; then
       exit 0
   fi
done < <(tail -n +2 "$databasesDirectory/$database/$table.txt")

exit 1

