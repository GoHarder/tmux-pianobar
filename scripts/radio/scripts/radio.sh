#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

temp_file="$RADIO_DIR/temp.txt"

press_key() {
   send_keys "$1"
}

start() {
   local session='Radio'

   # Check if the session exists, discarding output
   tmux has-session -t $session 2> /dev/null

   # Create the session if it doesn't exists.
   if [[ $? != 0 ]]; then
      # -d means it detached and wont pop up tmux automaticly
      tmux new-session -d -s "$session"
   fi

   tmux send-keys -t Radio:1 pianobar Enter
}

close() {
   send_keys q
   tmux kill-session -t Radio
}

get_data() {
   local read_data=$(get_tmux_option "@radio-read-data" 0)

   if [[ $read_data -gt 0 ]]; then
      cat "$temp_file"
   else
      echo ''
   fi
}

change_station() {
   local index="$1"
   send_keys s
   send_keys "$index" Enter
}