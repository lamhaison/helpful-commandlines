#!/bin/bash
peco_k8s_input() {
	lhs_peco_commandline_input "${1}" 'true'
}

peco_k8s_namespace_list() {
	peco_k8s_input "kubectl get namespaces | awk -F ' ' '{print \$1}' | grep -v 'NAME'"

}

peco_k8s_deployment_list() {
	peco_k8s_input "kubectl get deployments --all-namespaces \
		| awk -F ' ' 'BEGIN { OFS=\"  |   \" } { print \$2,\$1}' | grep -v 'NAME'"
}

peco_k8s_pod_list() {
	peco_k8s_input "kubectl get pods --all-namespaces \
		| awk -F ' ' 'BEGIN { OFS=\"  |   \" } { print \$2,\$1}' | grep -v 'NAME'"
}

peco_k8s_pod_list_reloaded() {
	lhs_peco_commandline_input "kubectl get pods --all-namespaces \
		| awk -F ' ' 'BEGIN { OFS=\"  |   \" } { print \$2,\$1}' | grep -v 'NAME'" 'false'
}

peco_k8s_ingress_list() {
	peco_k8s_input "kubectl get ingress --all-namespaces \
		| awk -F ' ' 'BEGIN { OFS=\"  |   \" } { print \$2,\$1}' | grep -v 'NAME'"

}
