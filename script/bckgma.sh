#!/bin/bash

PGUSER=leo-admin
PGPASSWORD=leo137skx]]
export PGUSER PGPASSWORD
dt=$(date +%Y%m%d%H%M%S)
db="localhost";
owner="leo-admin";
dbname="gma_prod";
filepath="/home/leo-admin/backup/gma"$dt".dump";
echo $filepath
pg_dump --format=c --no-owner --no-acl  --host=$db --username=$owner $dbname > $filepath
