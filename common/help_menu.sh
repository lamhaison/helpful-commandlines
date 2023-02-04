lamhaison_help() {
	BUFFER=$(
		cat ${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS}/*/*.sh |
			grep -e "^function.*\(.+*\)" | tr -d "(){" | cut -d ' ' -f2 | sort | peco --query "$LBUFFER"
	)

	CURSOR=$#BUFFER

}
