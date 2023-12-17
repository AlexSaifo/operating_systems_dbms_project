# When Deleting a Database, achieve the following:
# ● Only owners or admins can delete any database (private or public).
# ● Only empty databases can be deleted.
# ● Deleting a Database requires deleting the metadata of the Database.
# ● The script should show all the databases inside the Database directory to choose one to delete

#!/bin/bash
dir="databases"
# if ! test -r "${databases_path}"
# then
#    echo "Permission Denied."
#    exit 1
# fi

# Loop over all directories in the databases folder
x=0
for folder in $(ls -d -- ${dir}/*/)
do
    # Check if the current user can delete the directory
    if test -w ${folder}
    then
        # Check if the directory is empty
        if [ -z "$(ls -A ${folder})" ];
        then
            # Print the name of the directory
            x=$((x + 1))
            echo ${folder}
        fi
    fi
done
if [ $x -eq 0 ]
then
    echo "No Databases to be deleted"
    exit 1
fi
read -p "Enter database's name to be deleted: databases/" database_name


if [ ! -d "databases/${database_name}" ] || [ ! -w "databases/${database_name}" ] || [ -z $database_name ]
then
    echo "Invalid Database name"
    exit 1
fi

# Check if the directory is empty
if [ ! -z "$(ls -A "databases/${database_name}")" ];
then
    echo "database is not empty"
    exit 1
fi

set -e

# Delete the group
sudo groupdel $database_name || exit 1

# Delete the folder
rm -d "databases/${database_name}" || exit 1
echo "The database deleted successfully"
