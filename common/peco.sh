# brew install peco
# PECO
function peco_select_history() {
	local tac
	if which tac >/dev/null; then
		tac="tac"
	else
		# Displays the output from the end of the file in reverse order.
		tac="tail -r"
	fi
	BUFFER=$(history -n 1 | uniq |
		eval $tac |
		peco --query "$LBUFFER")
	# Move the cursor at then end of the input($#variable_name is to get the length itself)
	CURSOR=$#BUFFER
	# zle clear-screen
}

function peco_history() {
	peco_select_history
}
