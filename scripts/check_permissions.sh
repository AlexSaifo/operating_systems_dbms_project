#!/bin/bash

database_name=$1

if [ $1 = "-h" ]; then
    echo "Usage $0 [DATABASE_NAME]"
    exit 0
fi

if [ ! -d "../databases/${database_name}" ] || [ ! $2 "../databases/${database_name}" ] || [ -z $database_name ]
then
    exit 1
fi
exit 0