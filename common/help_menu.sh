function lhs_help_helpful() {
	# Support both function function_name() { or function_name with prefix aws_bla_bla() {
	local lhs_functions=$(lhs_peco_helpful_function_list)
	BUFFER=$(
		echo ${lhs_functions} | peco --query "$LBUFFER"
	)
	CURSOR=$#BUFFER

}

function lhs_help_all() {
	# Support both function function_name() { or function_name with prefix aws_bla_bla() {
	local lhs_functions=$(lhs_peco_function_list)
	BUFFER=$(
		echo ${lhs_functions} | peco --query "$LBUFFER"
	)
	CURSOR=$#BUFFER

}

function lhs_help_refresh() {
	lhs_peco_disable_input_cached
	lhs_peco_function_list >>/dev/null
	lhs_peco_helpful_function_list >>/dev/null
	lhs_peco_enable_input_cached

}
