#!/bin/bash
if [ $# -lt 1 ]; then 
  echo "usage: backup database_name"
  exit -1
fi

if [ $# -eq 1 ]; then 
  db=$1 
fi

echo "backup in corso"
nn="pp"$(date +%y%m%d%H%M)_$db".tar"
pg_dump --format=t --no-owner --no-acl --host=localhost --username=postgres $db > $nn
gzip $nn
echo "backup completato"
