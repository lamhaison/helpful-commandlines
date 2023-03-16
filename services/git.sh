#!/bin/bash

#
# TODO to scan git history and current source in the current directory that you run function
# @return
#
function lhs_git_scan_secrets() {
	local image_name="gitsecrets"
	lhs_docker_build_git_secret_image
	echo "\033[31m Scan history \033[0m"
	docker run --rm -v $(pwd):/repository:ro ${image_name} git secrets --scan-history
	echo "\033[31m Scan recursive \033[0m"
	docker run --rm -v $(pwd):/repository:ro ${image_name} git secrets --scan -r /repository
}
