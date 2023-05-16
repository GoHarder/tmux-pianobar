#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/radio.sh"

get_status() {
   local index=$(get_tmux_option "@radio-status-index" 0)
   local display=('title' 'artist' 'album')
   local data=$(get_data | grep "${display[index]}" | sed 's/^title/song/')

   echo $data | awk -F '=' '{print " " toupper(substr($1,1,1)) substr($1,2) " - " $2 " "}'

   (( $index >= 2 )) && index=-1
   (set_tmux_option "@radio-status-index" $(( $index + 1 )))
}

adjust_status_length() {
   local display="$1"
   local option=$(get_tmux_option 'status-right-length' 0)
   local length=${#display}

   length=$(( $length + $option ))
   set_tmux_option 'status-right-length' $length
}

main() {
   [[ -z $(pane_id) ]] && echo && return

   local str=$(get_status)

   adjust_status_length "$str"

   echo "$str" 
}

main "$@"