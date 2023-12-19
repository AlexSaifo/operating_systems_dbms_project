#!/bin/bash
dir="../databases"
x=0
for folder in $(ls -d -- ${dir}/*/)
do
    if test -w ${folder}
    then
        if [ ! -z "$(ls -A ${folder})" ];
        then
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
            if ! $all_files_one_line
            then
                echo ${folder}>&2
                x=$((x + 1))
            fi
        fi
    fi
done

if [ $x -eq 0 ]
then
    echo "No Databases to be emptied">&2
    echo "$database_name"
    exit 1
fi

read -p "Enter database's name to be deleted: databases/" database_name

if [ ! -d "../databases/${database_name}" ] || [ ! -w "../databases/${database_name}" ]|| [ -z $database_name ]
then
 echo "Invalid Database name">&2
 echo "$database_name"
 exit 1
fi

if [ -z "$(ls -A "../databases/${database_name}")" ];
then
 echo "database is empty">&2
 echo "$database_name"
 exit 1
fi

if [ ! -z "$(ls -A "../databases/${database_name}")" ];
then
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
    if  $all_files_one_line
    then
       echo "Database already empty!">&2
       echo $database_name
       exit 1
    fi
fi




for file in "../databases/${database_name}"/*
do
  if [[ -f $file ]]
  then
      sed -i '2,$d' "$file"
  fi
done

echo "database ${database_name} now is empty.">&2
echo "$database_name"
exit 0
