#!/bin/bash

file_path="/opt/log.txt"


dbname="$1"
status="$2"
note="$3"

role=$(./check_user.sh "$dbname")
data="$note:database name: $dbname $USER:"$role" $(date) status: $(if [ "$status" -eq 0 ]; then echo "true"; else echo "false"; fi)"
echo "$data" | tee -a "$file_path" > /dev/null
