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

function lhs_run_commandline_with_retry() {
	local lhs_commandline=$1
	local silent_mode=$2
	local retry_counter=0

	# Check credential valid first
	# lhs_assume_role_is_tmp_credential_valid

	while [[ "${retry_counter}" -le "${lhs_cli_retry_time}" ]]; do

		if [[ "${silent_mode}" = "true" ]]; then
			eval $lhs_commandline 2>/dev/null
		else
			eval $lhs_commandline
		fi

		if [[ $? -ne 0 ]]; then
			retry_counter=$(($retry_counter + 1))

			# if [[ "${silent_mode}" = "false" ]]; then
			# 	echo "Retry ${retry_counter}"
			# fi

			sleep ${lhs_cli_retry_sleep_interval}
		else
			break
		fi
	done

}

function lhs_run_commandline() {
	lhs_run_commandline=$1
	lhs_run_commandline="${lhs_run_commandline:?'lhs_run_commandline is unset or empty'}"
	lhs_run_commandline_with_logging "${lhs_run_commandline}"
}

function lhs_commandline_logging() {
	lhs_commandline_logging=$(echo ${1:?'lhs_commandline is unset or empty'} | tr -d '\t' | tr -d '\n')
	echo "Running commandline [ ${lhs_commandline_logging} ]"

}

function lhs_run_commandline_with_logging() {
	lhs_commandline=$1
	if [ "$lhs_show_log_uploaded" = "true" ]; then
		local tee_command="tee -a ${log_file_path} ${log_uploaded_file_path}"
	else
		local tee_command="tee -a ${log_file_path}"
	fi

	if [ "$lhs_show_commandline" = "true" ]; then
		local detail_commandline_tee_command="${tee_command}"
	else
		local detail_commandline_tee_command="${tee_command} > /dev/null"
	fi

	echo "------------------------------STARTED--$(date '+%Y-%m-%d-%H-%M-%S')-----------------------------------------" | eval $tee_command >/dev/null
	lhs_commandline_logging $1 | eval $detail_commandline_tee_command
	lhs_commandline_result=$(lhs_run_commandline_with_retry "${lhs_commandline}" "${ignored_error_when_retry}")
	echo $lhs_commandline_result | eval $tee_command
	echo "------------------------------FINISHED-$(date '+%Y-%m-%d-%H-%M-%S')-----------------------------------------" | eval $tee_command >/dev/null
}

function lhs_util_remove_space() {
	echo "${1}" | sed 's/[[:space:]]//g'
}