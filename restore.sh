if [ $# -lt 1 ]; then 
  echo "usage: restore database_name file_tar"
  exit -1
fi

if [ $# -eq 1 ]; then 
  db=$1 
  nf="pp.tar"
fi

if [ $# -eq 2 ]; then 
  db=$1 
  nf=$2
fi
echo restore del database $db

pg_restore --no-owner --no-acl --clean --host=localhost --username=postgres -d $db $nf

