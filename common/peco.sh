# brew install peco
# PECO
function peco_select_history() {
	local tac
	if which tac >/dev/null; then
		tac="tac"
	else
		# Displays the output from the end of the file in reverse order.
		tac="tail -r"
	fi
	BUFFER=$(history -n 1 | uniq |
		eval $tac |
		peco --query "$LBUFFER")
	# Move the cursor at then end of the input($#variable_name is to get the length itself)
	CURSOR=$#BUFFER
	# zle clear-screen
}

function peco_history() {
	peco_select_history
}

function lhs_peco_repo_list() {
	project_list=$(lhs_peco_commandline_input "find ${LHS_PROJECTS_DIR} -type d -name '.git' -maxdepth 6 | awk -F '.git' '{ print \$1}'" 'true' '60')
	input_project=$(echo ${project_list} | peco)
	echo ${input_project}
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
	local format_text=$(lhs_peco_format_name_convention_pre_defined $text_input)
	echo $format_text
}

function lhs_peco_create_menu_with_array_input() {
	local text_input=$1
	local format_text=$(lhs_peco_format_name_convention_pre_defined $text_input)
	echo $format_text
}

function lhs_peco_disable_input_cached() {
	export lhs_cli_peco_input_expired_time=0
}

function lhs_peco_run_command_to_get_input() {
	peco_commandline=$1
	eval ${peco_commandline}
}

function lhs_peco_commandline_input() {

	local commandline="${1}"
	local result_cached=$2
	local input_expired_time="${3:=$lhs_cli_peco_input_expired_time}"

	local md5_hash=$(echo $commandline | md5)
	local input_folder="${lhs_cli_input:=/tmp/inputs}"
	mkdir -p ${input_folder}
	local input_file_path="${input_folder}/${md5_hash}.txt"
	local empty_file=$(find ${input_folder} -name ${md5_hash}.txt -empty)
	local valid_file=$(find ${input_folder} -name ${md5_hash}.txt -mmin +${input_expired_time})

	# The file is existed and not empty and the flag result_cached is not empty
	if [ -z "${valid_file}" ] && [ -f "${input_file_path}" ] && [ -z "${empty_file}" ] && [ -n "${result_cached}" ]; then
		# Ignore the first line.
		grep -Ev "\*\*\*\*\*\*\*\* \[.*\]" $input_file_path
	else
		local commandline_result=$(lhs_peco_run_command_to_get_input "$commandline")

		local format_text=$(peco_format_output_text $commandline_result)

		if [ -n "${format_text}" ]; then
			echo "******** [ ${commandline} ] ********" >${input_file_path}
			echo ${format_text} | tee -a ${input_file_path}
		else
			echo "Can not get the data"
		fi

	fi

}

function lhs_peco_create_menu() {
	local input_function=$1
	local peco_options=$2
	local peco_command="peco ${peco_options}"
	local input_value=$(echo "$(eval $input_function)" | eval ${peco_command})
	echo ${input_value:?'Can not get the input from peco menu'}
}
