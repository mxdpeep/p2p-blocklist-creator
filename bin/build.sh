#!/bin/bash
#@author Fred Brooker <git@gscloud.cz>

source .env

if [ -z ${OUTPUT_FILE+x} ]; then
  echo "Missing OUTPUT_FILE definition!"
  exit 1
fi

BAR_SIZE="️▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
CLEAR_LINE="\\033[K"
MAX_BAR_SIZE="${#BAR_SIZE}"
TEMP_JSON="/tmp/p2p.json"

which curl >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Installing curl"
  sudo apt-get install curl -yq
fi

which wget >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Installing wget"
  sudo apt-get install wget -yq
fi

which jq >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Installing jq"
  sudo apt-get install jq -yq
fi

find . -type f -empty -delete

if [ ! -f "$TEMP_JSON" ]; then
  curl -s https://www.iblocklist.com/lists.json > $TEMP_JSON
fi

LIST=`cat $TEMP_JSON | jq -cr '.[]|.[]|select(.subscription == "false")|.list'`
tput civis

MAX_STEPS=0
for i in $LIST
do
  if [ "${#i}" -lt "3" ]; then continue; fi
  ((MAX_STEPS++))
done

c=0
for i in $LIST
do
  perc=$((c * 100 / MAX_STEPS))
  percBar=$((perc * MAX_BAR_SIZE / 100))
  if [ "${#i}" -lt "3" ]; then continue
    else echo -ne "\\r[${BAR_SIZE:0:percBar}] $perc % [$i] $CLEAR_LINE"
  fi
  ((c++))
  sleep 0.01
  if [ -f "$i.txt" ]; then continue; fi
  wget -q -O "$i.txt.gz" http://list.iblocklist.com/?list=$i
  gunzip *.gz
done

perc=100
percBar=$((perc * MAX_BAR_SIZE / 100))
echo -ne "\\r[${BAR_SIZE:0:percBar}] $perc % $CLEAR_LINE"

cat *.txt > $OUTPUT_FILE
LINES=`cat blocklist.p2p | wc -l`
echo -en "\n\nBlocklist created: $LINES lines\n\n"

tput cnorm
