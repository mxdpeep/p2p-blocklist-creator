#!/bin/bash

TEMP_JSON="/tmp/p2p.json"

which curl >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Installing curl package..."
  sudo apt-get install curl -yq
fi

which wget >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Installing wget package..."
  sudo apt-get install wget -yq
fi

which jq >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Installing jq package..."
  sudo apt-get install jq -yq
fi

if [ ! -f "$TEMP_JSON" ]; then
  curl https://www.iblocklist.com/lists.json > $TEMP_JSON
fi

LIST=`cat $TEMP_JSON | jq -cr '.[]|.[]|select(.subscription == "false")|.list'`

for i in $LIST
do
  if [ "${#i}" -lt "3" ]; then continue; fi
  if [ -f "$i.txt" ]; then continue; fi
  echo $i
  wget -q -O "$i.txt.gz" http://list.iblocklist.com/?list=$i
  gunzip *.gz
done

cat *.txt > blocklist.p2p
LINES=`cat blocklist.p2p | wc -l`

echo -en "\n\nBlocklist created: $LINES lines\n\n"

# push if mxdpeep is local user
if [ `whoami` == "mxdpeep" ]; then git commit -am "data rebuild"; git push origin master; fi
