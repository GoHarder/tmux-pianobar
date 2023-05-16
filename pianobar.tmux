#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$CURRENT_DIR/scripts"

source "$SCRIPTS_DIR/helpers.sh"
source "$SCRIPTS_DIR/variables.sh"

init_pack() {
   local option=$1
   local script=$2
   local setting=$(get_tmux_option $1 'off')

   # [[ $setting == 'off' ]] && return
      
   eval $script
}

main() {
   init_pack $ENABLE_RADIO_OPTION "$SCRIPTS_DIR/radio/pack.sh"
}

main