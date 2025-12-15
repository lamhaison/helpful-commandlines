#!/bin/bash

function peco_k8s_helm_list() {
	peco_k8s_input "lhs_helm_list_releases_all | grep -v 'NAMESPACE' \
		| awk -F '\t' 'BEGIN { OFS=\"  |   \" } { print \$1,\$2,\$3}' | grep -v 'NAME'"
}

function peco_k8s_helm_list_revisions() {
	local release_name=$1
	local namespace=$2

	# Check invalid input
	if [[ -z "${release_name}" || -z "${namespace}" ]]; then
		echo "Invalid input: release_name or namespace is empty"
		return 1
	fi


	peco_k8s_input "helm history '$release_name' -n '${namespace}' | grep -v 'REVISION' \
		| awk -F '\t' 'BEGIN { OFS=\"  |   \" } { print \$1,\$2,\$3,\$4,\$5,\$6}' | grep -v 'NAME'"
}
