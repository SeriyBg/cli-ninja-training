#!/bin/bash

usage() {

cat <<USAGE
Usage: patchprr <database name> <patch.sql>
USAGE

exit 1

}


if [ $# -lt 2 -o "x$1" == "x-h" -o "x$1" == "x--help" ]
then
  if [ $# == 1 ]
  then
    mysql -u root -e "SELECT * FROM (SELECT * FROM $1.Patches p ORDER BY p.ID DESC LIMIT 15) AS p ORDER BY p.ID"
  fi
  usage
fi


mysql -u root $1 < $2

rc=$?

if [ rc == 0 ]
then
  mysql -u root -e "INSERT INTO $1.Patches (Name, CreateTimestamp) VALUES ('$2', NOW())"
  echo Patch applied succesfully
fi
mysql -u root -e "SELECT * FROM (SELECT * FROM $1.Patches p ORDER BY p.ID DESC LIMIT 15) AS p ORDER BY p.ID"

