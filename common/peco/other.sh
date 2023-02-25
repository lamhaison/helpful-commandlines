#!/bin/bash

function lhs_peco_function_list() {
	local lhs_function_list_cmd="
		find ${LHS_HELPFUL_LOOKUP} -type f -name '*.sh' | grep -v main.sh | xargs cat | grep -e '^function.*\(.+*\)' -e '^aws*\(.+*\)' -e '^peco*\(.+*\)' -e '^lhs*\(.+*\)' \
		| tr -d '(){' | awk -F ' ' '{ print (\$1==\"function\") ? \$2 : \$1}' | sort
	"
	lhs_peco_commandline_input "${lhs_function_list_cmd}" "${LHS_HELPFUL_LOOKUP_CACHED}"

}

function lhs_peco_helpful_function_list() {
	local lhs_function_list_cmd="
		find ${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS} -type f -name '*.sh' | grep -v main.sh | xargs cat | grep -e '^function.*\(.+*\)' -e '^aws*\(.+*\)' -e '^peco*\(.+*\)' -e '^lhs*\(.+*\)' \
		| tr -d '(){' | awk -F ' ' '{ print (\$1==\"function\") ? \$2 : \$1}' | sort
	"
	lhs_peco_commandline_input "${lhs_function_list_cmd}" "${LHS_HELPFUL_LOOKUP_CACHED}"

}
