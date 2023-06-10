#!/bin/bash
#
# @version 		1.0
# @script		cmd_editor.sh
# @description	TODO : the tool that is using peco and tree to open project and edit it.
#
##

function lhs_editor_with_tree() {
	local tree_cmd="tree -afr ${1:-}"
	local editor_cmd="${2:-vim}"
	local file_name=$(eval ${tree_cmd} | peco --on-cancel error | awk -F "──" '{ print $2 }' | awk -F " " '{print $1}')

	if [[ -n "${file_name}" ]]; then
		${editor_cmd} -c 'set number' -c 'syn on' ${file_name}
	fi

}
