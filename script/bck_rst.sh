#!/bin/bash

PS3='Operazione di: '
echo
select ope in "Backup" "Restore"
do
  if [[ $ope = "Restore" ]]; then break
  elif [[ $ope = "Backup" ]]; then break
  else echo "Digitare 1 o 2 seguito da invio! (1:Backup - 2:Restore)"
  fi
done
echo -n "IP del database server (default localhost): "
read db
if [[ $db = "" ]]; then db="localhost"; fi
echo -n "Utente proprietario del database (default postgres): "
read owner
if [[ $owner = "" ]]; then owner="postgres"; fi
echo -n "Nome del database (default gma_dev): "
read dbname
if [[ $dbname = "" ]]; then dbname="gma_dev"; fi
echo -n "File di "$ope" (default ../backup/gma.dump): "
read filepath
if [[ $filepath = "" ]]; then filepath="../backup/gma.dump"; fi

if [[ $ope = "Backup" ]]
  then echo "inserire la password dell'utente "$owner" se richiesto"
  pg_dump --format=c --no-owner --no-acl  --host=$db --username=$owner $dbname > $filepath
  echo "E' stato creato il seguente file di backup: "
  ls -l $filepath
elif [[ $ope = "Restore" ]]
  then

  if [[ $db != "localhost" ]]
    then PS3="E' presente il client postgres in questo pc? : "
    select client in "Yes" "No"
    do
      if [[ $client = "Yes" ]]; then break
      elif [[ $client = "No" ]]; then break
      else echo "Digitare 1 o 2 seguito da invio! (1:Yes - 2:No)"
      fi
    done
  else
    client="Yes"
  fi

  if [[ $client = "Yes" ]]
    then echo 'Tutti i processi attivi sul database '$dbname' verranno terminati, premere invio per continuare'; read nil
    echo "SELECT pg_terminate_backend(pg_stat_activity.procpid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '"$dbname"';" > ./script/scriptdb
    echo "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '"$dbname"';" >> ./script/scriptdb
    echo "drop database "$dbname";" >> ./script/scriptdb
    echo "create database "$dbname";" >> ./script/scriptdb
    echo "inserire la password dell'utente "$owner" se richiesto"
    psql --host=$db --username=$owner --dbname='postgres' --file=./script/scriptdb
    rm ./script/scriptdb
  else echo 'Eseguire manualmente il drop e create del database '$dbname', premere invio per continuare'; read nil
  fi
  echo "inserire la password dell'utente "$owner" se richiesto"
  pg_restore --no-acl --no-owner --host=$db --username=$owner --dbname=$dbname $filepath 2> ../backup/err.log
  
  PS3="E' presente un web server apache in questo pc? : "
  select webs in "Yes" "No"
  do
    if [[ $webs = "Yes" ]]
      then echo "inserire la password dell'utente 'sudo' se richiesto"
      sudo service apache2 restart
      break
    elif [[ $webs = "No" ]]
      then echo 'Stoppare manualmente il webserver se presente, premere invio per continuare'
      read nil
      break
    else echo "Digitare 1 o 2 seguito da invio! (1:Yes - 2:No)"
    fi
  done
  echo "Elenco errori:"
  cat ../backup/err.log
  rm ../backup/err.log
  echo "Fine elenco errori"
else echo "ERRORE !!! : Condizione non possibile"
fi
