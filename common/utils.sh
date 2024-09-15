#!/bin/bash

# Get DateTime

function lhs_cmd_date_get_month() {
	date +%m
}

function lhs_cmd_date_get_year() {
	date +%Y
}
function lhs_cmd_date_get_with_format() {
	echo $(date "+"${1:-"%Y-%m-%d-%H-%M-%S"})
}

function lhs_cmd_date_get_with_format_yyyymmdd() {
	lhs_cmd_date_get_with_format "%Y%m%d"
}

function lhs_cmd_date_get_with_format_cw_log() {
	lhs_cmd_date_get_with_format "%Y-%m-%d %H:%M:%S"
}

function lhs_cmd_date_get_epoch_time() {
	# unix-time-in-milliseconds
	date -d '0 hour ago' +%s%N | cut -b1-13
}

# TODO function lhs_cmd_time_convert_echo_to_human_readable_formaton_name to convert epoch time to human readable formnat.
# @param	$1: the value of epoch time and $2: the formant(default is %Y-%m-%d-%H-%M-%S)
# @return
#
function lhs_cmd_time_convert_echo_to_human_readable_format() {

	# TODO Later (it didn't work rightnow)
	local default_date_format=+${2:-'%Y-%m-%d-%H-%M-%S'}
	date -r ${1:?'epoch_value is unset or empty'} ${default_date_format}
}

# Password generate
function lhs_cmd_password_generate() {
	# openssl rand -base64 10 | tr -d '='

	cd /tmp >/dev/null
	mktemp XXXXXXXXXXXXX
	cd - >/dev/null
}

# Get DateTime
function lhs_cmd_file_name_get_random_name() {
	local file_name=${1:-'FILENAME'}
	cd /tmp >/dev/null
	mktemp ${file_name}-XXXXXXXXXXXXXX
	cd - >/dev/null
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

function local_local_lhs_run_commandline_with_retry() {
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

function local_lhs_run_commandline() {
	local_lhs_run_commandline=$1
	local_lhs_run_commandline="${local_lhs_run_commandline:?'local_lhs_run_commandline is unset or empty'}"
	local_local_lhs_run_commandline_with_logging "${local_lhs_run_commandline}"
}

function local_lhs_commandline_logging() {

	local log_file_path=${aws_cli_logs}/${ASSUME_ROLE}.log
	local tee_command="tee -a ${log_file_path}"

	local eval_commandline=${2:-'False'}

	local local_lhs_commandline_logging=$(echo ${1:?'lhs_commandline is unset or empty'} | tr -d '\t' | tr -d '\n')

	if [[ "${eval_commandline}" == "True" ]]; then
		echo "${local_lhs_commandline_logging}"
	else
		echo "Running commandline [ ${local_lhs_commandline_logging} ]" | eval $tee_command
	fi

}

function local_local_lhs_run_commandline_with_logging() {
	lhs_commandline=$1
	if [[ "$lhs_show_log_uploaded" = "true" ]]; then
		local tee_command="tee -a ${lhs_cli_log_file_path} ${lhs_cli_log_uploaded_file_path}"
	else
		local tee_command="tee -a ${lhs_cli_log_file_path}"
	fi

	if [[ "$lhs_cli_show_commandline" = "true" ]]; then
		local detail_commandline_tee_command="${tee_command}"
	else
		local detail_commandline_tee_command="${tee_command} > /dev/null"
	fi

	echo "------------------------------STARTED--$(date '+%Y-%m-%d-%H-%M-%S')-----------------------------------------" | eval $tee_command >/dev/null
	local_lhs_commandline_logging $1 | eval $detail_commandline_tee_command
	lhs_commandline_result=$(local_local_lhs_run_commandline_with_retry "${lhs_commandline}" "${ignored_error_when_retry}")
	echo $lhs_commandline_result | eval $tee_command
	echo "------------------------------FINISHED-$(date '+%Y-%m-%d-%H-%M-%S')-----------------------------------------" | eval $tee_command >/dev/null
}

function local_lhs_util_rm_space() {
	# echo "${1}" | sed 's/[[:space:]]//g'
	# https://stackoverflow.com/questions/13659318/how-to-remove-space-from-string
	echo "${1//+([[:space:]])/}"
}

function local_lhs_util_format_commandline_one_line() {
	echo ${1} | tr -d '\t' | tr -d '\n' | tr -s ' '
}
