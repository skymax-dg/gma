#!/bin/bash

PGUSER=postgres
PGPASSWORD=Postgre_sql
export PGUSER PGPASSWORD
dt=$(date +%Y%m%d%H%M%S)
db="localhost";
owner="postgres";
dbname="gma_dev";
filepath="../backup/gma"$dt".dump";
echo $filepath
pg_dump --format=c --no-owner --no-acl  --host=$db --username=$owner $dbname > $filepath
