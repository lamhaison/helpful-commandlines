#!/bin/bash

# Get DateTime

function lhs_cmd_date_get_month() {
	date +%m
}

function lhs_cmd_date_get_year() {
	date +%Y
}
function lhs_cmd_date_get_with_format() {
	date "+${1:-"%Y-%m-%d-%H-%M-%S"}"
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

function local_local_lhs_run_commandline_with_retry() {
	local lhs_commandline=$1
	local silent_mode=$2
	local retry_counter=0

	# Check credential valid first
	# lhs_assume_role_is_tmp_credential_valid

	# Skip SC2154
	# shellcheck disable=SC2154
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

	local log_file_path
	local tee_command
	local eval_commandline
	local lhs_commandline
	local local_lhs_commandline_logging

	lhs_commandline=$1
	eval_commandline=${2:-'False'}

	# shellcheck disable=SC2154
	# Check if ASSUME_ROLE is set, if it is not set, use hostname as log file name
	if [[ -z "${ASSUME_ROLE}" ]]; then
		log_file_path=${aws_cli_logs}/$(hostname).log
	else
		log_file_path=${aws_cli_logs}/${ASSUME_ROLE}.log
	fi

	tee_command="tee -a ${log_file_path}"

	# Validate lhs_commandline

	if [[ -z "${lhs_commandline}" ]]; then
		echo "❌ lhs_commandline is empty"
		return 1
	fi

	local_lhs_commandline_logging=$(echo "${lhs_commandline}" | tr -d '\t' | tr -d '\n')

	if [[ "${eval_commandline}" == "True" ]]; then
		echo "${local_lhs_commandline_logging}"
	else
		echo "Running commandline [ ${local_lhs_commandline_logging} ]" | eval $tee_command
	fi

}

function local_local_lhs_run_commandline_with_logging() {
	lhs_commandline=$1

	# shellcheck disable=SC2154
	if [[ "$lhs_show_log_uploaded" = "true" ]]; then
		local tee_command="tee -a ${lhs_cli_log_file_path} ${lhs_cli_log_uploaded_file_path}"
	else
		local tee_command="tee -a ${lhs_cli_log_file_path}"
	fi


	# shellcheck disable=SC2154
	if [[ "$lhs_cli_show_commandline" = "true" ]]; then
		local detail_commandline_tee_command="${tee_command}"
	else
		local detail_commandline_tee_command="${tee_command} > /dev/null"
	fi

	echo "------------------------------STARTED--$(date '+%Y-%m-%d-%H-%M-%S')-----------------------------------------" | eval $tee_command >/dev/null
	local_lhs_commandline_logging $1 | eval $detail_commandline_tee_command
	# shellcheck disable=SC2154
	# ignored_error_when_retry is defined in main.sh
	lhs_commandline_result=$(local_local_lhs_run_commandline_with_retry "${lhs_commandline}" "${ignored_error_when_retry}")
	echo $lhs_commandline_result | eval $tee_command
	echo "------------------------------FINISHED-$(date '+%Y-%m-%d-%H-%M-%S')-----------------------------------------" | eval $tee_command >/dev/null
}

function local_lhs_util_rm_space() {
	# Remove spaces from the input string
	echo "${1}" | tr -d '\t' | tr -d ' '
}

function local_lhs_util_format_commandline_one_line() {
	echo ${1} | tr -d '\t' | tr -d '\n' | tr -s ' '
}

# Replace by using lhs-cli later
function lhs_cmd_file_name_get_random_name() {
	local file_name=${1:-'FILENAME'}
	echo "${file_name}-$(lhs_cmd_date_get_with_format)"
}
