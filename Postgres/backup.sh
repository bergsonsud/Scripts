#!/bin/bash
#
#
#
TIME=`date +bak_%d-%m-%Y_.sql`
FILENAME=$TIME
#   
#
#
/usr/bin/pg_dump --host localhost --port 5432 --username "postgres" --no-password --no-owner --column-inserts --file "/home/bergson/Backup/"$FILENAME "sgcli"