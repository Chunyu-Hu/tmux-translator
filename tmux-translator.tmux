#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/settings.sh"

set_launch_bindings() {
	local key_bindings=$(get_tmux_option "$launch_key" "$default_launch_key")
	local key
	for key in $key_bindings; do
		tmux bind-key -T copy-mode "$key" send-keys -X copy-pipe-and-cancel "$CURRENT_DIR/scripts/main.sh"
		tmux bind-key -T copy-mode-vi "$key" send-keys -X copy-pipe-and-cancel "$CURRENT_DIR/scripts/main.sh"
	done

	key_bindings=$(get_tmux_option "$launch_key_clipboad" "$default_launch_key_clipboard")
	for key in $key_bindings; do
		tmux bind-key -T copy-mode "$key" send-keys -X copy-pipe-and-cancel "$CURRENT_DIR/scripts/main.sh clipboard"
		tmux bind-key -T copy-mode-vi "$key" send-keys -X copy-pipe-and-cancel "$CURRENT_DIR/scripts/main.sh clipboard"
	done
}

set_launch_bindings
