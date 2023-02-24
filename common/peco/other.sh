#!/bin/bash

function lhs_peco_function_list() {
	local lhs_function_list_cmd="
		find ${LHS_HELPFUL_LOOKUP} -type f -name '*.sh' | grep -v main.sh | xargs cat | grep -e '^function.*\(.+*\)' -e '^aws*\(.+*\)' -e '^peco*\(.+*\)' \
		| tr -d '(){' | awk -F ' ' '{ print (\$1==\"function\") ? \$2 : \$1}' | sort
	"
	lhs_peco_commandline_input "${lhs_function_list_cmd}" 'true'

}
