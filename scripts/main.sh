#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/settings.sh"

get_width() {
	local key_bindings=$(get_tmux_option "$width" "$default_width")
	local key
	for key in $key_bindings; do
		local value=$key
	done
	echo "$value"
}

get_height() {
	local key_bindings=$(get_tmux_option "$height" "$default_height")
	local key
	for key in $key_bindings; do
		local value=$key
	done
	echo "$value"
}

get_from() {
	local key_bindings=$(get_tmux_option "$from" "$default_from")
	local key
	for key in $key_bindings; do
		local value=$key
	done
	echo "$value"
}

get_to() {
	local key_bindings=$(get_tmux_option "$to" "$default_to")
	local key
	for key in $key_bindings; do
		local value=$key
	done
	echo "$value"
}

get_engine() {
	local key_bindings=$(get_tmux_option "$engine" "$default_engine")
	local key
	for key in $key_bindings; do
		local value=$key
	done
	echo "$value"
}

primary=$(xclip -o -sel p | awk '{print $1}')
clipboard=$(xclip -o -sel clipboard | awk '{print $1}')
buffer=$(tmux save-buffer -)
target=${1:-buffer}
reserve=${2:-""}

vars=$(echo "$(get_engine)" | sed "s/|/\n/g")
if [ -n "$reserve" ]; then
	var=$from
	from=$to
	to=$var
fi

while IFS= read -r line; do
    result="${result}echo ---$line---; echo ${!target} | xargs -I{} python $CURRENT_DIR/../engine/translator.py --phonetic --engine=$line --from=$(get_from) --to=$(get_to) {}; echo ''; "
done <<< "$vars"

result="${result}read -r"

tmux popup -w $(get_width) -h $(get_height) -E "$result"
