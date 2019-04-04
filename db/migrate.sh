#!/bin/bash


export PROJECT_ROOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $PROJECT_ROOT_PATH


HOST="localhost"
PORT="5432"
DBNAME="twittey"
USER="twittey_master"
PASSWORD="$(jq -r '.twittey_master.password' users.json)"

DIRECTION="$1"
NUM="$2"


if [ "$DIRECTION" == "start" ]; then
    PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -d $DBNAME -U $USER -f migration.sql

elif [ "$DIRECTION" == "up" ]; then
    PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -d $DBNAME -U $USER -f defs/$NUM.$DIRECTION.sql

elif [[ "$DIRECTION" == "down" ]]; then
    PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -d $DBNAME -U $USER -f defs/$NUM.$DIRECTION.sql

else
    echo "unknown option"

fi