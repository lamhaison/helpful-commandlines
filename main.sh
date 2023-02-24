# Get the current directory of the main.sh script.
export HELPFUL_COMMANDLINES_SOURCE_SCRIPTS="$(dirname -- "$0")"

# Extend for poco-select-history function
# export HISTSIZE=20000
# export SAVEHIST=15000
# https://github.com/mattjj/my-oh-my-zsh/blob/master/history.zsh
HISTFILE="$HOME/.zhistory"
HISTSIZE=10000000
SAVEHIST=10000000

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

export LHS_PROJECTS_DIR=~/projects
# Get all history from folder /opt/lamhaison-tools
export LHS_HELPFUL_LOOKUP="${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS}/.."

# Import sub-commandline.
# https://yukimemi.netlify.app/all-you-need-is-peco/
# https://thevaluable.dev/zsh-line-editor-configuration-mouseless/
for script in $(find ${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS} -type f -name '*.sh' | grep -v main.sh); do
	source $script
done

export lhs_cli_peco_input_expired_time=10
export lhs_cli_show_commandline=true
export lhs_cli_input=/tmp/lhs/inputs
export lhs_cli_logs=/tmp/lhs/logs
mkdir -p ${lhs_cli_input} ${lhs_cli_logs}
export lhs_cli_log_file_path="${lhs_cli_logs}/lhs-cli.log"
export lhs_cli_log_uploaded_file_path="${lhs_cli_logs}/lhs-cli-uploaded.log"
# Add hot-keys
zle -N peco_select_history
bindkey '^r' peco_select_history

zle -N lhs_help
bindkey '^h' lhs_help
