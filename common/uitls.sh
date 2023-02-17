#!/bin/bash

# Get DateTime
function lhs_date_get_with_format() {
	echo $(date "+%Y-%m-%d-%H-%M-%S")
}

# Password generate
function lhs_password_generate() {
	# openssl rand -base64 10 | tr -d '='
	mktemp XXXXXXXXXXXXX
}

# Get DateTime
function lhs_file_name_get_random_name() {
	local file_name=${1:='FILENAME'}
	mktemp ${file_name}-XXXXXXXXXXXXXX
}

# Trap to handle Ctrl+C
# Do later
# function lhs_demo_script_trap_handle_hotkey_ctrl_c() {

# 	set -x
# 	TMPFILE1=$(mktemp /tmp/im1.XXXXXX)
# 	TMPFILE2=$(mktemp /tmp/im2.XXXXXX)

# 	while [[ true ]]; do
# 		echo "Press Ctrl + C to exit"
# 		sleep 10
# 	done

# 	trap "rm -f $TMPFILE1 $TMPFILE2; exit 1" INT --snip--

# 	set +x
# }
