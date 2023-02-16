lamhaison_help_helpful() {
	# Support both function function_name() { or function_name with prefix aws_bla_bla() {
	BUFFER=$(
		cat $(find ${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS} -type f -name '*.sh' | grep -v main.sh) |
			grep -e "^function.*\(.+*\)" -e "^aws*\(.+*\)" -e "^peco*\(.+*\)" | tr -d "(){" | awk -F ' ' '{ print ($1=="function") ? $2 : $1}' | sort | peco --query "$LBUFFER"
	)
	CURSOR=$#BUFFER

}

lamhaison_help() {
	# Support both function function_name() { or function_name with prefix aws_bla_bla() {
	BUFFER=$(
		echo ${LAMHAISON_FUNCTIONS} | peco --query "$LBUFFER"
	)
	CURSOR=$#BUFFER

}
