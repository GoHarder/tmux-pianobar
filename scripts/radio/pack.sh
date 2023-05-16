#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$CURRENT_DIR/scripts"

source "$SCRIPTS_DIR/helpers.sh"
source "$SCRIPTS_DIR/variables.sh"

set_default_key_binding_options() {
	set_tmux_option "${VAR_KEY_PREFIX}-${MENU_KEY}" "bash -c 'source $SCRIPTS_DIR/menu.sh main'"
}

set_key_bindings() {
   local stored_key_vars="$(stored_key_vars)"
   local key value

  	for option in $stored_key_vars; do
		key="$(get_key_from_option_name $option)"
		value="$(get_value_from_option_name $option)"

      tmux bind-key -n "$key" run-shell "$value"
	done
}

set_status_variable() {
   local cmd="$SCRIPTS_DIR/status.sh"
   local option=$(get_tmux_option 'status-right')
   local output=${option/"#{radio}"/"#($cmd)"}

   $(set_tmux_option 'status-right' "$output")
}

main() {
   set_default_key_binding_options
   set_key_bindings
   set_status_variable
}

main