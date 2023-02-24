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

function peco_repo_list() {
	project_list=$(peco_commandline_input "find ${LHS_PROJECTS_DIR} -type d -name '.git' -maxdepth 6 | awk -F '.git' '{ print \$1}'" 'true' '60')
	input_project=$(echo ${project_list} | peco)
	echo ${input_project}
}

peco_format_name_convention_pre_defined() {
	local peco_input=$1
	echo "${peco_input}" | tr "\t" "\n" | tr -s " " "\n" | tr -s '\n'
}

peco_format_aws_output_text() {
	local peco_input=$1
	echo "${peco_input}" | tr "\t" "\n"
}

peco_aws_acm_list() {
	aws_acm_list | peco
}

peco_name_convention_input() {
	local text_input=$1
	local format_text=$(peco_format_name_convention_pre_defined $text_input)
	echo $format_text
}

peco_create_menu_with_array_input() {
	local text_input=$1
	local format_text=$(peco_format_name_convention_pre_defined $text_input)
	echo $format_text
}

peco_aws_disable_input_cached() {
	export peco_input_expired_time=0
}

peco_aws_input() {
	peco_commandline_input "${1} --output text" $2
}

peco_run_command_to_get_input() {
	peco_commandline=$1
	eval ${peco_commandline}
}

peco_commandline_input() {

	local commandline="${1}"
	local result_cached=$2
	local input_expired_time="${3:=$peco_input_expired_time}"

	local md5_hash=$(echo $commandline | md5)
	local input_folder="${lhs_input_tmp:=/tmp}"
	mkdir -p ${input_folder}
	local input_file_path="${input_folder}/${md5_hash}.txt"
	local empty_file=$(find ${input_folder} -name ${md5_hash}.txt -empty)
	local valid_file=$(find ${input_folder} -name ${md5_hash}.txt -mmin +${input_expired_time})

	# The file is existed and not empty and the flag result_cached is not empty
	if [ -z "${valid_file}" ] && [ -f "${input_file_path}" ] && [ -z "${empty_file}" ] && [ -n "${result_cached}" ]; then
		# Ignore the first line.
		grep -Ev "\*\*\*\*\*\*\*\* \[.*\]" $input_file_path
	else
		local aws_result=$(peco_run_command_to_get_input "$commandline")

		local format_text=$(peco_format_aws_output_text $aws_result)

		if [ -n "${format_text}" ]; then
			echo "******** [ ${commandline} ] ********" >${input_file_path}
			echo ${format_text} | tee -a ${input_file_path}
		else
			echo "Can not get the data"
		fi

	fi

}

peco_create_menu() {
	local input_function=$1
	local peco_options=$2
	local peco_command="peco ${peco_options}"
	local input_value=$(echo "$(eval $input_function)" | eval ${peco_command})
	echo ${input_value:?'Can not get the input from peco menu'}
}
