lhs_help_helpful() {
	# Support both function function_name() { or function_name with prefix aws_bla_bla() {
	local lhs_functions=$(lhs_peco_helpful_function_list)
	BUFFER=$(
		echo ${lhs_functions} | peco --query "$LBUFFER"
	)
	CURSOR=$#BUFFER

}

lhs_help_all() {
	# Support both function function_name() { or function_name with prefix aws_bla_bla() {
	local lhs_functions=$(lhs_peco_function_list)
	BUFFER=$(
		echo ${lhs_functions} | peco --query "$LBUFFER"
	)
	CURSOR=$#BUFFER

}
