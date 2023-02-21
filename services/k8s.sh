#!/bin/bash
# https://kubernetes.io/docs/reference/kubectl/cheatsheet/

function lhs_k8s_get_cluster_info() {
	kubectl cluster-info
}

function lhs_k8s_list_pods_for_namespace() {
	local lhs_k8s_ns_name=$1
	kubectl get pods -n ${lhs_k8s_ns_name:?'lhs_k8s_ns_name is unset or empty'} -o wide
}

function lhs_k8s_list_all_pods() {
	kubectl get pods --all-namespaces
}

function lhs_k8s_get_pods_with_hint() {
	lhs_k8s_get_namespaces

	echo "kubectl get pods -n ${lhs_k8s_ns_name:='\$lhs_k8s_ns_name'}"
}

function lhs_k8s_get_namespaces() {
	kubectl get namespaces
}

function lhs_k8s_get_nodes() {
	kubectl get nodes
}

function lhs_k8s_list_pod_images() {
	kubectl get pods \
		--all-namespaces \
		--output=custom-columns="NAME:.metadata.name,IMAGE:.spec.containers[*].image"
}

function lhs_k8s_list_deployments() {
	kubectl get deployments --all-namespaces
}

function lhs_k8s_get_dashboard_token() {
	local lhs_k8s_dashboard_ns_name=$1
	local lhs_k8s_dashboard_secret_name=$2

	kubectl -n ${lhs_k8s_dashboard_ns_name} describe secret \
		$(kubectl -n ${lhs_k8s_dashboard_ns_name} get secret | grep ${lhs_k8s_dashboard_secret_name} | awk '{print $1}')
}
