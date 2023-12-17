
echo "Available databases:"
ls ../Databases

read -p "Enter the name of the Database to delete data from: " dbname

if [[ ! -d "/project/Databases/$dbname" ]]; then
  echo "Database '$dbname' does not exist."
  exit 1
fi

echo "Tables in Database '$dbname':"
ls "../Databases/$dbname"

read -p "Enter the name of the table to delete data from: " tablename

if [[ ! -f "../Databases/$dbname/$tablename" ]]; then
  echo "Table '$tablename' does not exist in Database '$dbname'."
  exit 1
fi
  
  attributes=$(head -n 1 "../Databases/$dbname/$tablename")
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
    echo "$new_data" >> "../Databases/$dbname/${tablename}_temp"
    edited=true
    continue
  fi
  echo "$line" >> "../Databases/$dbname/${tablename}_temp" 
  done < "../Databases/$dbname/$tablename"
  mv "../Databases/$dbname/${tablename}_temp" "../Databases/$dbname/$tablename"
  if [ "$edited" == true ];then
    echo -e "data edited successfully \xF0\x9F\x98\x81"
  else 
    echo -e "id not found nothing has changed \xF0\x9F\x99\x81"
    
  fi
  echo -e "made with love \xE2\x9D\xA4 kosai"