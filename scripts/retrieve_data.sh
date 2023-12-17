
databasesDirectory="../databases"

echo "Available databases:">&2
ls $databasesDirectory>&2

read -p "Enter the name of the Database to retrieve data from: " dbname

if [[ ! -d "$databasesDirectory/$dbname" ]]; then
  echo "Database '$dbname' does not exist.">&2
  echo "$dbname"
  exit 1
fi

echo "Tables in Database '$dbname':">&2
ls "$databasesDirectory/$dbname">&2

read -p "Enter the name of the table to retrieve data from: " tablename

if [[ ! -f "$databasesDirectory/$dbname/$tablename.txt" ]]; then
  echo "Table '$tablename' does not exist in Database '$dbname'.">&2
  echo "$dbname"
  exit 1
fi

echo "Choose retrieval option:">&2
echo "1. Retrieve all table data">&2
echo "2. Retrieve data based on specific criteria">&2

read -p "Enter the option (1 or 2): " option

case $option in
  1)
    cat "$databasesDirectory/$dbname/$tablename.txt">&2
    echo "$dbname"
    exit 0
    ;;
  2)
    read -p "Enter the value to search for: " search_value>&2
    grep -i "$search_value" "$databasesDirectory/$dbname/$tablename.txt">&2
    echo "$dbname"
    exit 0 
    ;;
  *)
    echo "Invalid option. Exiting.">&2
    echo "$dbname"
    exit 1
    ;;
esac
