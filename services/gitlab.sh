#!/bin/bash

function lamhaison_gitlab_list() {
	curl --silent -q "https://gitlab.com/api/v4/projects?private_token=${GITLAB_TOKEN}&membership=true" |
		jq '.[].ssh_url_to_repo' | grep "git" | awk -F '"' '{print $2}'
	# TODO LATER (Can not get full repo as calling api)
	# glab repo list --member | grep "git" | awk -F " " '{print $2}'
}
