#!/bin/bash
#
# @version 		1.0
# @script		main.sh
# @description	TODO : to load function for helpful-commandlines
# $1: Where is looking for sh files and source the list
# $2: Do you want to set the bind key?
# $3: To change history settings

HELPFUL_COMMANDLINES_SOURCE_SCRIPTS=$1

if [[ -z "${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS}" ]]; then
	# Get the current directory of the main.sh script.
	LOCAL_HELPFUL_COMMANDLINES_SOURCE_SCRIPTS=$(dirname -- "$0")
	if [[ "${LOCAL_HELPFUL_COMMANDLINES_SOURCE_SCRIPTS}" = "." ]]; then
		DEFAULT_HELPFUL_COMMANDLINES_SOURCE_SCRIPTS='/opt/lamhaison-tools/helpful-commandlines'
	fi

	export HELPFUL_COMMANDLINES_SOURCE_SCRIPTS="${LOCAL_HELPFUL_COMMANDLINES_SOURCE_SCRIPTS:-${DEFAULT_HELPFUL_COMMANDLINES_SOURCE_SCRIPTS}}"
else
	export HELPFUL_COMMANDLINES_SOURCE_SCRIPTS=${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS}
fi

# Extend for poco-select-history function
# export HISTSIZE=20000
# export SAVEHIST=15000
# https://github.com/mattjj/my-oh-my-zsh/blob/master/history.zsh

LHS_CHANGE_HISTORY_SETTINGS=${3:-'True'}

if [[ "${LHS_CHANGE_HISTORY_SETTINGS}" = "True" ]]; then
	export HISTFILE="$HOME/.zhistory"
	export HISTSIZE=10000
	export SAVEHIST=10000
	# Ignore duplicates in command history and increase
	export HISTCONTROL=ignoredups

	setopt BANG_HIST              # Treat the '!' character specially during expansion.
	setopt EXTENDED_HISTORY       # Write the history file in the ":start:elapsed;command" format.
	setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
	setopt SHARE_HISTORY          # Share history between all sessions.
	setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.

	setopt HIST_IGNORE_DUPS     # Don't record an entry that was just recorded again.
	setopt HIST_IGNORE_ALL_DUPS # Delete old recorded entry if new entry is a duplicate.
	setopt HIST_FIND_NO_DUPS    # Do not display a line previously found.
	setopt HIST_IGNORE_SPACE    # Don't record an entry starting with a space.
	setopt HIST_SAVE_NO_DUPS    # Don't write duplicate entries in the history file.
	setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks before recording entry.
	setopt HIST_VERIFY          # Don't execute immediately upon history expansion.
	setopt HIST_BEEP            # Beep when accessing nonexistent history.
fi

export LHS_PROJECTS_DIR=~/projects
# Get all history from folder /opt/lamhaison-tools
export LHS_HELPFUL_LOOKUP="${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS}/.."
export LHS_HELPFUL_LOOKUP_CACHED=true

# Import sub-commandline.
# https://yukimemi.netlify.app/all-you-need-is-peco/
# https://thevaluable.dev/zsh-line-editor-configuration-mouseless/
for script in $(find ${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS} -type f -name '*.sh' | grep -v main.sh | grep -v test.sh | grep -v temp.sh); do
	source $script
done

export lhs_cli_peco_input_expired_time=10
export lhs_cli_show_commandline=true
export lhs_cli_input=/tmp/lhs/inputs
export lhs_cli_logs=/tmp/lhs/logs
mkdir -p ${lhs_cli_input} ${lhs_cli_logs}
export lhs_cli_log_file_path="${lhs_cli_logs}/lhs-cli.log"
export lhs_cli_log_uploaded_file_path="${lhs_cli_logs}/lhs-cli-uploaded.log"

LHS_BIND_KEY=${2:-'True'}

if [[ "${LHS_BIND_KEY}" = "True" ]]; then
	# Add hot-keys
	zle -N lhs_peco_select_history
	bindkey '^r' lhs_peco_select_history

	zle -N lhs_help_all
	bindkey '^h' lhs_help_all

	# Hot key for git commit suggestions
	zle -N lhs_git_commit_suggestions_with_hint
	# Hotkey: Option + gc
	bindkey '©ç' lhs_git_commit_suggestions_with_hint
fi
