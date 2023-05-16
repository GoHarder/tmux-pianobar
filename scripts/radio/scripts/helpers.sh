#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="${CURRENT_DIR%/*/*}"

source "$BASE_DIR/helpers.sh"

pane_id() {
   tmux list-panes -a -F '#{pane_id} #{pane_current_command}' |
      grep 'pianobar' | awk '{print $1}'
}

send_keys() {
   local pane_id="$(pane_id)"
   
   [ -z "$pane_id" ] && exit 0

   tmux send-keys -t "$pane_id" $@
}