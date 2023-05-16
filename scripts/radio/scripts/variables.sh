#!/usr/bin/env bash

VAR_KEY_PREFIX="@desktop-radio-key"

MENU_KEY="M-/"
MENU_OPTION="@desktop-radio-menu"

radio_dir() {
	local DIR_XDG="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/desktop_radio"
	local DIR_OLD="$HOME/.tmux/desktop_radio"

	if [ -d "$DIR_XDG" ]; then
		echo "$DIR_XDG"
	elif [ -d "$DIR_OLD" ]; then
		echo "$DIR_OLD"
	else
		echo "$DIR_XDG"
	fi
}

RADIO_DIR="$(radio_dir)"