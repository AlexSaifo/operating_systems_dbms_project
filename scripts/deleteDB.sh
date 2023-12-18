# When Deleting a Database, achieve the following:
# ● Only owners or admins can delete any database (private or public).
# ● Only empty databases can be deleted.
# ● Deleting a Database requires deleting the metadata of the Database.
# ● The script should show all the databases inside the Database directory to choose one to delete

#!/bin/bash
dir="../databases"
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
        else
            all_files_one_line=true

            for file in "$folder"/*
            do
            if [[ -f $file ]]
            then
                num_lines=$(wc -l < "$file")
                if (( num_lines > 1 ))
                then
                    all_files_one_line=false
                    break
                fi
            fi
            done

            if $all_files_one_line
            then
                echo ${folder}
                x=$((x + 1))
            fi
        fi
    fi
done
if [ $x -eq 0 ]
then
    echo "No Databases to be deleted">&2
    echo "$database_name"
    exit 1
fi
read -p "Enter database's name to be deleted: databases/" database_name


if [ ! -d "../databases/${database_name}" ] || [ ! -w "../databases/${database_name}" ] || [ -z $database_name ]
then
    echo "Invalid Database name">&2
    echo "$database_name"
    exit 1
fi

# Check if the directory is valid
all_files_one_line=true

for file in "../databases/${database_name}"/*
do
if [[ -f $file ]]
then
    num_lines=$(wc -l < "$file")
    if (( num_lines > 1 ))
    then
        all_files_one_line=false
        break
    fi
fi
done

if ! $all_files_one_line
then
    echo "database is not empty">&2
    echo "$database_name"
    exit 1
fi

set -e

# Delete the group
sudo groupdel $database_name || exit 1

# Delete the folder
yes | rm -d -r "../databases/${database_name}" || exit 1
echo "The database deleted successfully">&2
echo "$database_name"
exit 0
