
databasesDirectory="../databases"

# echo "Available databases:">&2
# ls $databasesDirectory>&2

read -p "Enter the name of the Database to delete data from: " dbname

if [[ ! -d "$databasesDirectory/$dbname" ]]; then
  echo "Database '$dbname' does not exist.">&2
  echo "$dbname"
  exit 1
fi

echo "Tables in Database '$dbname':">&2
ls "$databasesDirectory/$dbname">&2

# ./check_permissions.sh  "$dbname" -r

# if [ $? != 0 ]; then
#   echo "permission denied">&2
#   exit 1
# fi 

read -p "Enter the name of the table to delete data from: " tablename

if [[ ! -f "$databasesDirectory/$dbname/$tablename.txt" ]]; then
  echo "Table '$tablename' does not exist in Database '$dbname'.">&2
  echo "$dbname"
  exit 1
fi
  
  attributes=$(head -n 1 "$databasesDirectory/$dbname/$tablename.txt")
  IFS=',' read -ra attributes_list <<< "$attributes"
  
  read -p "Enter the id of the row you want to edit:" selected_id
  
  new_data_list=()
  new_data_list+=("$selected_id")
  for item in "${attributes_list[@]}"; do
    if [ "$item" == "id" ]; then 
      continue  
    fi
    read -p "$item: " value
    new_data_list+=("$value")
    
  done
  
  new_data=""
  for item in "${new_data_list[@]}"; do
    if [ -z "$new_data" ]; then
        new_data="$item"
    else
        new_data+="$result,$item"
    fi
  done

  pattern="^$selected_id,[^,]*"

  edited=false
  while IFS= read -r line
  do
  if echo "$line" | grep -qE "$pattern"; then
    echo "$new_data" >> "$databasesDirectory/$dbname/${tablename}_temp"
    edited=true
    continue
  fi
  echo "$line" >> "$databasesDirectory/$dbname/${tablename}_temp" 
  done < "$databasesDirectory/$dbname/$tablename.txt"
  yes | mv "$databasesDirectory/$dbname/${tablename}_temp" "$databasesDirectory/$dbname/$tablename.txt"
  if [ "$edited" == true ];then
    echo -e "data edited successfully \xF0\x9F\x98\x81">&2
  else 
    echo -e "id not found nothing has changed \xF0\x9F\x99\x81">&2
    
  fi
  echo "$dbname"
  exit 0