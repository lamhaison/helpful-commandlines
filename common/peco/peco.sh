# shellcheck disable=SC2148
# brew install peco
# PECO

function lhs_peco_setting_set_filter_type_with_regex_option() {
	lhs_peco_setting_set_filter_type_for_history_search "Regexp"
	lhs_peco_setting_set_filter_type "Regexp"
}

function lhs_peco_setting_set_filter_type_for_history_search() {
	filter_type=$1

	# Check input invalid
	if [[ -z "$filter_type" ]]; then return; fi
	unset LHS_PECO_FILTER_HISTORY_TYPE
	export LHS_PECO_FILTER_HISTORY_TYPE=${1:-'IgnoreCase'}
	echo "Set the filter type for history commandline by peco is ${filter_type}"

}

function lhs_peco_setting_set_filter_type() {
	filter_type=$1
	# Check input invalid
	if [[ -z "$filter_type" ]]; then return; fi
	unset LHS_PECO_FILTER_TYPE
	export LHS_PECO_FILTER_TYPE=${1:-'IgnoreCase'}
	echo "Set the filter type global for peco is ${filter_type}"

}

function lhs_peco_setting_set_filter_type_for_history_search_with_hint() {

	# shellcheck disable=SC2155
	local lhs_docs=$(
		cat <<-__EOF__
			IgnoreCase
			CaseSensitive
			SmartCase
			Regexp
			Fuzzy
		__EOF__
	)

	# shellcheck disable=SC2155
	local filter_type=$(echo "$lhs_docs" | peco)

	# Check input is valid and process it
	[ -z "$filter_type" ] || lhs_peco_setting_set_filter_type_for_history_search "${filter_type}"

}

function lhs_peco_setting_set_filter_type_with_hint() {

	# shellcheck disable=SC2155
	local lhs_docs=$(
		cat <<-__EOF__
			IgnoreCase
			CaseSensitive
			SmartCase
			Regexp
			Fuzzy
		__EOF__
	)

	# shellcheck disable=SC2155
	local filter_type=$(echo "$lhs_docs" | peco)

	# Check input is valid and process it
	[ -z "$filter_type" ] || lhs_peco_setting_set_filter_type "${filter_type}"

}

function lhs_peco_select_history() {
	local tac
	if which tac >/dev/null; then
		tac="tac"
	else
		# Displays the output from the end of the file in reverse order.
		tac="tail -r"
	fi
	BUFFER=$(history -n 1 | uniq |
		eval $tac |
		peco --query "$LBUFFER" --initial-filter ${LHS_PECO_FILTER_HISTORY_TYPE})
	# peco --query "$LBUFFER")
	# Move the cursor at then end of the input($#variable_name is to get the length itself)
	CURSOR=$#BUFFER
	# zle clear-screen
}

function lhs_peco_repo_list() {
	# Almost expired (1000000)
	project_list=$(
		lhs_peco_commandline_input "\
			find ${LHS_PROJECTS_DIR} -type d -name '.git' -maxdepth 8 \
			| awk -F '/' '{for (i=1; i<NF; i++) printf \$i \"/\"; print '\n'}'" 'true' '0'
	)

	local final_projects=$(
		cat <<-__EOF__			
			${project_list}
		__EOF__
	)

	input_project=$(echo "${final_projects}" | sort | uniq | peco)
	echo "${input_project}"
}

function lhs_peco_format_name_convention_pre_defined() {
	local peco_input=$1
	echo "${peco_input}" | tr "\t" "\n" | tr -s " " "\n" | tr -s '\n'
}

function lhs_peco_format_output_text() {
	local peco_input=$1
	echo "${peco_input}" | tr "\t" "\n"
}

function lhs_peco_name_convention_input() {
	local text_input=$1
	local format_text
	format_text=$(lhs_peco_format_name_convention_pre_defined "$text_input")
	echo "$format_text"
}

function lhs_peco_create_menu_with_array_input() {
	local text_input=$1
	local format_text
	format_text=$(lhs_peco_format_name_convention_pre_defined "$text_input")
	echo "$format_text"
}

function lhs_peco_disable_input_cached() {
	export lhs_cli_peco_input_expired_time=-1
}

function lhs_peco_enable_input_cached() {
	export lhs_cli_peco_input_expired_time=10
}

function lhs_peco_run_command_to_get_input() {
	peco_commandline=$1
	eval "${peco_commandline}"
}

function lhs_peco_commandline_input() {

	# set -x
	local commandline="${1}"
	local result_cached=${2:-'false'}
	local input_expired_time="${3:-$lhs_cli_peco_input_expired_time}"
	local input_file_path
	local md5_hash
	local input_folder
	local empty_file
	local valid_file
	local commandline_result
	local format_text
	
	md5_hash=$(echo "$commandline" | md5)
	input_folder="${lhs_cli_input:-/tmp/inputs}"
	
	# Check folder exists
	if [[ ! -d "${input_folder}" ]]; then
		mkdir -p "${input_folder}"
	fi

	input_file_path="${input_folder}/${md5_hash}.txt"
	empty_file=$(find "${input_folder}" -name "${md5_hash}.txt" -empty)


	# Disable cache as global setting
	if [[ "$lhs_cli_peco_input_expired_time" = "-1" ]]; then
		result_cached=false
	elif [[ "$input_expired_time" -eq 0 ]]; then
		# If input_expired_time is 0, cache without expiration (TTL is unlimited)
		valid_file=$(find "${input_folder}" -name "${md5_hash}.txt")
	elif [[ "$input_expired_time" -gt 0 ]]; then
		# If input_expired_time is greater than 0, find the file that is not expired
		# Check the file is created within the input_expired_time
		valid_file=$(find "${input_folder}" -name "${md5_hash}.txt" -mmin -"${input_expired_time}")
	else
		# Default behavior for negative values other than -1
		result_cached=false
	fi

	
	# The file is existed and not empty and the flag result_cached is not empty
	if [[ "true" == "${result_cached}" ]] && [[ -f "${input_file_path}" ]] && [[ -z "${empty_file}" ]] && [[ -n "${valid_file}" ]]; then
		# echo "load from cache"
		# Ignore the first line.
		grep -Ev "\*\*\*\*\*\*\*\* \[.*\]" "$input_file_path"
	else
		# echo "Query and save to cache"
		commandline_result=$(lhs_peco_run_command_to_get_input "$commandline")

		format_text=$(lhs_peco_format_output_text "$commandline_result")

		if [[ -n "${format_text}" ]]; then
			commandline=$(local_lhs_util_format_commandline_one_line "${commandline}")
			echo "******** [ ${commandline} ] ********" >"${input_file_path}"
			echo "${format_text}" | tee -a "${input_file_path}"
		else
			echo "Can not get the data"
		fi

	fi

	# set +x

}

function lhs_peco_create_menu() {
	local input_function=$1
	local peco_options=$2
	local peco_command="peco ${peco_options}"
	local input_value

	# Check input_function is valid
	if [[ -z "$input_function" ]]; then
		echo "Input function is empty"
		return 1
	fi

	input_value=$(eval "${input_function}" | eval "${peco_command}")
	echo "${input_value:?'Can not get the input from peco menu'}"
}
