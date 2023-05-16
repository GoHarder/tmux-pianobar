#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/radio.sh"

main() {
   case "$1" in
      'change_station')
         change_station_menu;;
      'radio')
         radio_menu;;
      'song')
         song_menu;;
      'station')
         station_menu;;
      'main')
         main_menu;;
   esac
}

key_cmd() {
   echo "run-shell 'bash -c \"source $CURRENT_DIR/radio.sh; press_key $1\"'"
}

menu_cmd() {
   echo "run-shell 'bash -c \"source $CURRENT_DIR/menu.sh $1\"'"
}

change_cmd() {
   echo "run-shell 'bash -c \"source $CURRENT_DIR/radio.sh; change_station $1\"'"
}

main_menu() {
   [ -z $(pane_id) ] && start_menu

   local data=$(get_data | sed 's/^title/song/')

   while read line; do
      key="$(echo "$line" | cut -d '=' -f 1)"
	   value="$(echo "$line" | cut -d '=' -f 2)"
      local "$key"="$value"
   done <<< "$data"

   tmux display-menu -T "( ${stationName:-Pianobar} )" -x R -y P \
      "" \
      "-#[nodim]Song:   $song"   "" "" \
      "-#[nodim]Artist: $artist" "" "" \
      "-#[nodim]Album:  $album"  "" "" \
      "" \
      'Play/Pause'   'p'   "$(key_cmd p)" \
      'Next'         'n'   "$(key_cmd n)" \
      '' \
      'Radio menu'   ''    "$(menu_cmd radio)" \
      'Station menu' ''    "$(menu_cmd station)" \
      'Song menu'    ''    "$(menu_cmd song)" \
      '' \
      'Close'        'q'  ''
}

radio_menu() {
   tmux display-menu -T "( Radio Menu )" -x R -y P \
      'View feed'    'v'   'switch-client -t Radio' \
      'Close radio'  'c'   'kill-session -t Radio' \
      '' \
      'Back'         'b'   "$(menu_cmd main)"
}

song_menu() {
   tmux display-menu -T "( Song Menu )" -x R -y P \
      'Tired of song'   't'   "$(key_cmd t)" \
      'Thumbs up'       '+'   "$(key_cmd +)" \
      'Thumbs down'     '-'   "$(key_cmd -)" \
      '' \
      'Back'            'b'   "$(menu_cmd main)"
}

station_menu() {
   tmux display-menu -T "( Station Menu )" -x R -y P \
      'Change Station'  's'   "$(menu_cmd change_station)" \
      '' \
      'Back'            'b'   "$(menu_cmd main)"
}

change_station_menu() {
   local data=$(get_data | grep -e 'station[0-9]*=' | awk -F '=' '{print substr($1,8,2) "=" $2}')
   local cmd='tmux display-menu -T "( Change Station )" -x R -y P '

   while read line; do
      local title="$(echo "$line" | cut -d '=' -f 2)"
      local num="$(echo "$line" | cut -d '=' -f 1)"
      cmd+="'$title' '' \"\$(change_cmd $num)\" " 
   done <<< "$data"

   cmd+="'' 'Back' 'b' \"\$(menu_cmd station)\""

   eval "$cmd"
}

start_menu() {
   tmux display-menu -T "( Pianobar )" -x R -y P \
      'Open radio'   ''   "run-shell 'bash -c \"source $CURRENT_DIR/radio.sh; start\"'" \
      '' \
      'Close'   'q'   ''
   exit 0
}

main "$@"
