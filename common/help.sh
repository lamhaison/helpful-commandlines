lamhaison_help() {
	lamhaison_commandline=$(
		cat ${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS}/*/*.sh |
			grep -e "^function.*\(.+*\)" | tr -d "(){" | cut -d ' ' -f2 | sort | peco
	)
	echo You can run which ${lamhaison_commandline:?"The commandline is unset or empty. Then do nothing"} to get more detail
}
