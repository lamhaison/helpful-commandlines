#!/bin/bash

# There ares some bugs, then I will overwrite it and use it in help_menu.sh of private-helpful-commandlines. # TODO Later (Fix latter, can't not get the function name - lhs_proj_rakkar_infra_aws_migrate_from_original_to_private_dns_record_for_dev)
function lhs_peco_function_list() {
	# Ignore private function
	local lhs_function_list_cmd="
		find \"${LHS_HELPFUL_LOOKUP}\" \
  			-type d \( -name 'docs' -o -name 'snippets' -o -name '.git' \) -prune \
  			-o -type f -name '*.sh' -print \
		| grep -v main.sh | xargs cat | grep -v '^function.*private.*' \
		| grep -e '^function.*\(.+*\)' -e '^aws*\(.+*\)' -e '^peco*\(.+*\)' -e '^lhs*\(.+*\)' \
		| tr -d '(){' | awk -F ' ' '{ print (\$1==\"function\") ? \$2 : \$1}' | sort
	"
	# Cache in LHS_HELPFUL_LOOKUP_FUNCTIONS_CACHED_EXPIRED_TIME setting
	lhs_peco_commandline_input "${lhs_function_list_cmd}" "${LHS_HELPFUL_LOOKUP_CACHED}" "${LHS_HELPFUL_LOOKUP_FUNCTIONS_CACHED_EXPIRED_TIME}"

}

function lhs_peco_helpful_function_list() {
	local lhs_function_list_cmd="
		find \"${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS}\" \
  			-type d \( -name 'docs' -o -name 'snippets' -o -name '.git' \) -prune \
  			-o -type f -name '*.sh' -print \
		| grep -v main.sh | xargs cat | grep -e '^function.*\(.+*\)' -e '^aws*\(.+*\)' -e '^peco*\(.+*\)' -e '^lhs*\(.+*\)' \
		| tr -d '(){' | awk -F ' ' '{ print (\$1==\"function\") ? \$2 : \$1}' | sort
	"

	# Cache in 1 minute
	lhs_peco_commandline_input "${lhs_function_list_cmd}" "${LHS_HELPFUL_LOOKUP_CACHED}" "1"

}
