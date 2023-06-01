#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

temp_file="$RADIO_DIR/temp.txt"

mkdir -p "$RADIO_DIR"

[[ ! -e "$temp_file" ]] && touch "$temp_file"

data=""

case "$1" in
   'songstart')
      data=$(grep -e '^\(title\|artist\|album\|stationName\|station[0-9]*\)=' /dev/stdin);;
   'usergetstations')
      data=$(grep -e '^\(station[0-9]*\)=' /dev/stdin);;
   'stationfetchplaylist')
      data=$(grep -e '^\(stationName\)=' /dev/stdin);;
   *)
      while read line; do
	      key="$(echo "$line" | cut -d '=' -f 1)"
	      value="$(echo "$line" | cut -d '=' -f 2)"
	      export "$key=$value"
      done < <(grep -e '^\(pRet\|pRetStr\|wRet\|wRetStr\)=' /dev/stdin);;
esac

[ -z "$data" ] && exit

set_tmux_option "@radio-read-data" 0

while read line; do
   key="$(echo "$line" | cut -d '=' -f 1)"
   value="$(echo "$line" | cut -d '=' -f 2 | sed 's/\([/&^@!|#]\)/\\\1/g')"
   matches=$(grep -c "$key=" $temp_file)

   if [[ $matches -gt 0 ]]; then
      sed -i "s/$key=.*/$key=${value//&/\\&}/" $temp_file
   else
      echo "$key=$value" >> "$temp_file"
   fi
done <<< "$data"

filter="\(Edition\|Remaster\|Explicit\|Deluxe\|Version\)"

sed -i "/^$/d;s/ (.*$filter.*)//;s/ \[.*$filter.*\]//;" $temp_file

set_tmux_option "@radio-read-data" 1

# if [ "$pRet" -ne 1 ]; then
#    echo "$pRetStr"
# elif [ "$wRet" -ne 1 ]; then
#    echo "$wRetStr"
# fi

# artist=Datarock
# title=Fa-Fa-Fa
# album=Datarock Datarock
# coverArt=http://mediaserver-cont-usc-mp1-2-v4v6.pandora.com/images/2a/7c/8f/cc/369e48c4be13505fe039d493/1080W_1080H.jpg
# stationName=Thumbprint Radio
# songStationName=
# pRet=1
# pRetStr=Everything is fine :)
# wRet=0
# wRetStr=No error
# songDuration=309
# songPlayed=0
# rating=0
# detailUrl=http://www.pandora.com/datarock/datarock-datarock/fa-fa-fa/TRfmfqg56mqPzdK?dc=63626&ad=1:39:1:63460::0:0:0:0:717::MO:29103:2:0:0:0:0:1
# stationCount=13
# station0=Beck Radio
# station1=Blur Radio
# station2=Courtney Barnett Radio
# station3=Devo Radio
# station4=Gorillaz Radio
# station5=Jack White Radio
# station6=LCD Soundsystem Radio
# station7=Pixies Radio
# station8=QuickMix
# station9=Radiohead Radio
# station10=Talking Heads Radio
# station11=The New Pornographers Radio
# station12=Thumbprint Radio

# artistbookmark
# songban
# songbookmark
# songexplain
# songfinish
# songlove
# songmove
# songshelf
# songstart
# stationaddgenre
# stationaddmusic
# stationaddshared
# stationcreate
# stationdelete
# stationdeleteartistseed
# stationdeletefeedback
# stationdeletesongseed
# stationfetchinfo
# stationfetchplaylist
# stationfetchgenre
# stationquickmixtoggle
# stationrename
# userlogin
# usergetstations