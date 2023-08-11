#!/bin/bash

function lhs_peco_function_list() {
	# Ignore private function
	local lhs_function_list_cmd="
		find ${LHS_HELPFUL_LOOKUP} -type f -name '*.sh' \
			-not -path \"${LHS_HELPFUL_LOOKUP}/private-helpful-commandlines/tmp/*\" \
			-not -path \"${LHS_HELPFUL_LOOKUP}/dotfiles/*\" \
		| grep -v main.sh | xargs cat | grep -v '^function.*private.*' \
		| grep -e '^function.*\(.+*\)' -e '^aws*\(.+*\)' -e '^peco*\(.+*\)' -e '^lhs*\(.+*\)' \
		| tr -d '(){' | awk -F ' ' '{ print (\$1==\"function\") ? \$2 : \$1}' | sort
	"
	# Cache in LHS_HELPFUL_LOOKUP_FUNCTIONS_CACHED_EXPIRED_TIME setting
	lhs_peco_commandline_input "${lhs_function_list_cmd}" "${LHS_HELPFUL_LOOKUP_CACHED}" "${LHS_HELPFUL_LOOKUP_FUNCTIONS_CACHED_EXPIRED_TIME}"

}

function lhs_peco_helpful_function_list() {
	local lhs_function_list_cmd="
		find ${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS} -type f -name '*.sh' \
			-not -path \"${LHS_HELPFUL_LOOKUP}/private-helpful-commandlines/tmp/*\" \
			-not -path \"${LHS_HELPFUL_LOOKUP}/dotfiles/*\" \
		| grep -v main.sh | xargs cat | grep -e '^function.*\(.+*\)' -e '^aws*\(.+*\)' -e '^peco*\(.+*\)' -e '^lhs*\(.+*\)' \
		| tr -d '(){' | awk -F ' ' '{ print (\$1==\"function\") ? \$2 : \$1}' | sort
	"

	# Cache in 1 minute
	lhs_peco_commandline_input "${lhs_function_list_cmd}" "${LHS_HELPFUL_LOOKUP_CACHED}" "1"

}
