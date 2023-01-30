# Get the current directory of the main.sh script.
export HELPFUL_COMMANDLINES_SOURCE_SCRIPTS="$(dirname -- "$0")"

# Import sub-commandline.
# https://yukimemi.netlify.app/all-you-need-is-peco/
# https://thevaluable.dev/zsh-line-editor-configuration-mouseless/
for module in $(echo "common"); do
	for script in $(ls ${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS}/${module}); do
		source ${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS}/${module}/${script}
	done
done

# Add hot-keys
zle -N peco_select_history
bindkey '^r' peco_select_history

zle -N lamhaison_help
bindkey '^h' lamhaison_help

# zle -N aws_assume_role_set_name_with_hint
# bindkey '^@' aws_assume_role_set_name_with_hint
