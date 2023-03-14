#!/bin/bash
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
INPUT=`tail -n +1 $SCRIPTPATH/config.csv`
OLDIFS=$IFS
IFS=','
while read owner repo branch path folder
do
  curl -o /tmp/${repo}.zip https://github.com/${owner}/${repo}/archive/refs/heads/${branch}.zip -O -J -L
  unzip /tmp/${repo}.zip -d /tmp
  rm -f /tmp/${repo}.zip
  FOLDER=`echo $folder | tr ' ' '-' | tr '[:upper:]' '[:lower:]'`
  rsync -a -v /tmp/${repo}-${branch}/${path} $SCRIPTPATH/../pages/$FOLDER
  rm -rf /tmp/${repo}-${branch}
done <<< $INPUT
IFS=$OLDIFS
