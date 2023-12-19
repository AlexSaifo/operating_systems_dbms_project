
databasesDirectory="../databases"


read -p "Enter the name of the Database to delete data from: " dbname

if [[ ! -d "$databasesDirectory/$dbname" ]]; then
  echo "Database '$dbname' does not exist.">&2
  echo "$dbname"
  exit 1
fi

echo "Tables in Database '$dbname':">&2

  
ls "$databasesDirectory/$dbname">&2

read -p "Enter the name of the table to delete data from: " tablename

if [[ ! -f "$databasesDirectory/$dbname/$tablename.txt" ]]; then
  echo "Table '$tablename' does not exist in Database '$dbname'.">&2
  echo "$dbname"
  exit 1
fi

echo "Select deletion option:">&2
echo "1. Delete all table data">&2
echo "2. Delete data based on specific criteria">&2
read -p "Enter the option (1 or 2): " option

if [ "$option" == "1" ]; then
  read -p "Are you sure: " confirm
  if [ "$confirm" == "yes" ]; then
  attributes=$(head -n 1 "$databasesDirectory/$dbname/$tablename.txt")
  echo "$attributes" > "$databasesDirectory/$dbname/$tablename.txt"
  echo "All data in Table '$tablename' deleted successfully.">&2
  echo "$dbname"
  exit 0
  else 
    echo "$dbname"
    exit 1
  fi
elif [ "$option" == "2" ]; then
 
  
  attributes=$(head -n 1 "$databasesDirectory/$dbname/$tablename.txt")
  
  
  comma_count=0
  current_column=""
  echo "available columns are : ">&2
  for ((i = 0; i < ${#attributes}; i++)); do
    if [ "$current_char" == "," ]; then
      echo "$current_column">&2
      current_column=""
    fi
    current_char="${attributes:$i:1}"
    current_column+=$current_char
  done
  echo "$current_column">&2

  current_column=""
  read -p "Enter the name of the column to delete data based on: " column
  read -p "Enter the value to search for: " value
  
  if [[ "$attributes" != *"$column"* ]]; then
    echo "the column entered does not exist in the table :(">&2
    echo "$dbname"
    exit 1
  fi

  for ((i = 0; i < ${#attributes}; i++)); do
    current_char="${attributes:$i:1}"
    current_column+=$current_char
    if [ "$current_column" == "$column" ]; then
      break
    fi

    if [ "$current_char" == "," ]; then
      ((comma_count++))
      current_column=""
    fi
  done
  
  
  echo "the index is $comma_count"
  
  pattern="^([^,]*,){$comma_count}$value"
  
  while IFS= read -r line
  do
  if ! echo "$line" | grep -qE "$pattern"; then 
  echo "$line" >> "$databasesDirectory/$dbname/${tablename}_temp"
  fi
  done < "$databasesDirectory/$dbname/$tablename.txt"
  mv "$databasesDirectory/$dbname/${tablename}_temp" "$databasesDirectory/$dbname/$tablename.txt"
  echo "Data in Table '$tablename' deleted successfully based on the specified criteria.">&2
  echo "$dbname"
  exit 0
else
  echo "Invalid option. Please enter either '1' or '2'.">&2
  echo "$dbname"
  exit 1
fi
