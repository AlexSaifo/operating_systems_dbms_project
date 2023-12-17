
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

echo "Select deletion option:"
echo "1. Delete all table data"
echo "2. Delete data based on specific criteria"
read -p "Enter the option (1 or 2): " option

if [ "$option" == "1" ]; then
  read -p "Are you sure: " confirm
  if [ "$confirm" == "yes" ]; then
  attributes=$(head -n 1 "../Databases/$dbname/$tablename")
  echo "$attributes" > "../Databases/$dbname/$tablename"
  echo "All data in Table '$tablename' deleted successfully."
  else 
    exit 1
  fi
elif [ "$option" == "2" ]; then
 
  
  attributes=$(head -n 1 "../Databases/$dbname/$tablename")
  
  
  comma_count=0
  current_column=""
  echo "available columns are : "
  for ((i = 0; i < ${#attributes}; i++)); do
    if [ "$current_char" == "," ]; then
      echo "$current_column"
      current_column=""
    fi
    current_char="${attributes:$i:1}"
    current_column+=$current_char
  done
  echo "$current_column"

  current_column=""
  read -p "Enter the name of the column to delete data based on: " column
  read -p "Enter the value to search for: " value
  
  if [[ "$attributes" != *"$column"* ]]; then
    echo "the column entered does not exist in the table :("
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
  echo "$line" >> "../Databases/$dbname/${tablename}_temp"
  fi
  done < "../Databases/$dbname/$tablename"
  mv "../Databases/$dbname/${tablename}_temp" "../Databases/$dbname/$tablename"
  echo "Data in Table '$tablename' deleted successfully based on the specified criteria."
else
  echo "Invalid option. Please enter either '1' or '2'."
  exit 1
fi
