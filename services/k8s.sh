#!/bin/bash
# https://kubernetes.io/docs/reference/kubectl/cheatsheet/

function lhs_kubectl_run_commandline() {
	lhs_run_commandline "$1"
}

function lhs_k8s_get_cluster_info() {

	lhs_kubectl_run_commandline "\
		kubectl cluster-info
	"

}

function lhs_k8s_list_pods_for_namespace() {
	local lhs_k8s_ns_name=$1
	lhs_kubectl_run_commandline "\
		kubectl get pods -n ${lhs_k8s_ns_name:?'lhs_k8s_ns_name is unset or empty'} -o wide
	"
}

function lhs_k8s_get_pod() {
	lhs_kubectl_run_commandline "\
		kubectl describe pod ${1:?'lhs_k8s_pod_name is unset or empty'} \
			-n ${2:?'lhs_k8s_ns_name is unset or empty'}
	"
}

function lhs_k8s_get_pods_with_hint() {
	local lhs_k8s_input=$(lhs_peco_create_menu 'peco_k8s_pod_list')
	local lhs_k8s_pod_name=$(echo ${lhs_k8s_input} | awk -F "|" '{print $1}')
	local lhs_k8s_ns_name=$(echo ${lhs_k8s_input} | awk -F "|" '{print $2}')

	lhs_k8s_get_pod ${lhs_k8s_pod_name} ${lhs_k8s_ns_name}

}

function lhs_k8s_list_all_pods() {

	lhs_kubectl_run_commandline "\
		kubectl get pods --all-namespaces
	"
}

function lhs_k8s_list_pods() {
	local lhs_k8s_ns_name=$1
	lhs_kubectl_run_commandline "\
		kubectl get pods -n ${lhs_k8s_ns_name:?'lhs_k8s_ns_name is unset or empty'}
	"
}

function lhs_k8s_list_pods_with_hint() {
	lhs_k8s_list_pods $(lhs_peco_create_menu 'peco_k8s_namespace_list')
}

function lhs_k8s_get_namespaces() {

	lhs_kubectl_run_commandline "\
		kubectl get namespaces
	"
}

function lhs_k8s_get_nodes() {
	lhs_kubectl_run_commandline "\
		kubectl get nodes
	"

}

function lhs_k8s_list_pod_images() {
	kubectl get pods \
		--all-namespaces \
		--output=custom-columns="NAME:.metadata.name,IMAGE:.spec.containers[*].image"
}

function lhs_k8s_get_pod_logs() {
	lhs_commandline_logging "\
		kubectl logs -f ${1:?'lhs_k8s_pod_name is unset or empty'} \
			-n ${lhs_k8s_ns_name:?'lhs_k8s_ns_name is unset or empty'}
	"

	kubectl logs -f ${1:?'lhs_k8s_pod_name is unset or empty'} \
		-n ${lhs_k8s_ns_name:?'lhs_k8s_ns_name is unset or empty'}

}

function lhs_k8s_get_pod_logs_with_hint() {
	local lhs_k8s_input=$(lhs_peco_create_menu 'peco_k8s_pod_list')
	local lhs_k8s_pod_name=$(lhs_util_remove_space $(echo ${lhs_k8s_input} | awk -F "|" '{print $1}'))
	local lhs_k8s_ns_name=$(lhs_util_remove_space $(echo ${lhs_k8s_input} | awk -F "|" '{print $2}'))

	lhs_k8s_get_pod_logs ${lhs_k8s_pod_name} ${lhs_k8s_ns_name}
}

# K8s Deployment

function lhs_k8s_list_deployments() {
	local lhs_k8s_ns_name=$1
	local lhs_cmd="kubectl get deployments --all-namespaces"
	# Is not empty
	if [[ -n "${lhs_k8s_ns_name}" ]]; then
		lhs_cmd="kubectl get deployments -n ${lhs_k8s_ns_name}"
	fi

	lhs_kubectl_run_commandline ${lhs_cmd}

}

function lhs_k8s_set_default_namespace() {
	export lhs_k8s_ns_name=${1:?'lhs_k8s_ns_name is unset or empty'}
}

function lhs_k8s_set_default_namespace_with_hint() {
	export lhs_k8s_ns_name=$(lhs_peco_create_menu 'peco_k8s_namespace_list')
}

function lhs_k8s_get_deployment() {

	lhs_kubectl_run_commandline "\
		kubectl get deployment ${1:?'lhs_k8s_deployment_name is unset or empty'} \
			-n ${2:?'lhs_k8s_ns_name is unset or empty'}
	"

	lhs_kubectl_run_commandline "\
		kubectl describe deployment ${1:?'lhs_k8s_deployment_name is unset or empty'} \
			-n ${2:?'lhs_k8s_ns_name is unset or empty'}
	"
}

function lhs_k8s_get_deployment_logs() {
	local lhs_k8s_cmd="
		kubectl logs -f deploy/${1:?'lhs_k8s_deployment_name is unset or empty'} \
			-n ${2:?'lhs_k8s_ns_name is unset or empty'}
	"
	lhs_commandline_logging ${lhs_k8s_cmd}
	eval ${lhs_k8s_cmd}

}

function lhs_k8s_get_deployment_logs_with_hint() {
	local lhs_k8s_input=$(lhs_peco_create_menu 'peco_k8s_deployment_list')
	local lhs_k8s_deployment_name=$(lhs_util_remove_space $(echo ${lhs_k8s_input} | awk -F "|" '{print $1}'))
	local lhs_k8s_ns_name=$(lhs_util_remove_space $(echo ${lhs_k8s_input} | awk -F "|" '{print $2}'))
	lhs_k8s_get_deployment_logs ${lhs_k8s_deployment_name} ${lhs_k8s_ns_name}
}

function lhs_k8s_get_deployment_with_hint() {
	local lhs_k8s_input=$(lhs_peco_create_menu 'peco_k8s_deployment_list')
	local lhs_k8s_deployment_name=$(lhs_util_remove_space $(echo ${lhs_k8s_input} | awk -F "|" '{print $1}'))
	local lhs_k8s_ns_name=$(lhs_util_remove_space $(echo ${lhs_k8s_input} | awk -F "|" '{print $2}'))
	lhs_k8s_get_deployment ${lhs_k8s_deployment_name} ${lhs_k8s_ns_name}
}

function lhs_k8s_list_all_deployments() {
	lhs_k8s_list_deployments
}

function lhs_k8s_list_deployments_for_namespace() {
	lhs_k8s_list_deployments $(lhs_peco_create_menu 'peco_k8s_namespace_list')
}

function lhs_k8s_get_dashboard_token() {
	local lhs_k8s_dashboard_ns_name=$1
	local lhs_k8s_dashboard_secret_name=$2

	kubectl -n ${lhs_k8s_dashboard_ns_name} describe secret \
		$(kubectl -n ${lhs_k8s_dashboard_ns_name} get secret | grep ${lhs_k8s_dashboard_secret_name} | awk '{print $1}')
}
