#!/bin/bash

BAR_SIZE="️▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
CLEAR_LINE="\\033[K"
MAX_BAR_SIZE="${#BAR_SIZE}"
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
  curl -s https://www.iblocklist.com/lists.json > $TEMP_JSON
fi

LIST=`cat $TEMP_JSON | jq -cr '.[]|.[]|select(.subscription == "false")|.list'`
tput civis -- invisible

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

cat *.txt > blocklist.p2p

LINES=`cat blocklist.p2p | wc -l`
echo -en "\n\nBlocklist created: $LINES lines\n\n"

# push if mxdpeep is local user
if [ `whoami` == "mxdpeep" ]; then git commit -am "data rebuild"; git push origin master; fi

tput cnorm -- normal

exit 0
