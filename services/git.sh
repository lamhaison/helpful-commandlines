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

function lhs_git_commit_suggestions() {

	# More instruction - https://www.freecodecamp.org/news/how-to-write-better-git-commit-messages/
	#             	   - https://chiamakaikeanyi.dev/how-to-write-good-git-commit-messages/
	# Set default git commit message - https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration
	cat <<-__EOF__
		git commit -m "[Add] - Your add description"
		git commit -m "[Improvement] - for enhancements"
		git commit -m "[Update] - Your update description"
		git commit -m "[Remove] - remove somethings such as functions, temp file, ..."
		git commit -m "[Feat] – a new feature is introduced with the changes"
		git commit -m "[Fix] - a bug fix has occurred"
		git commit -m "[Chore] – for updating dependencies"
		git commit -m "[Refactor] - refactored code that neither fixes a bug nor adds a feature"
		git commit -m "[Docs] - updates to documentation such as a the README or other markdown files"
		git commit -m "[Style] - related to code formatting such as white-space, missing semi-colons, and so on"
		git commit -m "[Test] - including new or correcting previous tests"
		git commit -m "[Perf] – performance improvements"
		git commit -m "[CiCd] - continuous integration and continuous delivery related"
		git commit -m "[Build] – changes that affect the build system or external dependencies"
		git commit -m "[Revert] - reverts a previous commit"
		git commit -m "[Release] - Your Release description (Comment for the PR)"

		+ Example(You have to add git commit -m "" manually):
			Ex: git commit -m "[Feat] - improve performance with lazy load implementation for images"
			Ex: git commit -m "[Chore] - update npm dependency to latest version"
			Ex: git commit -m "[Fix] - bug preventing users from submitting the subscribe form"
			Ex: git commit -m "[Update] -  incorrect client phone number within footer body per client request"
			Ex: git commit -m "[Refactor] - to refactor function names"
			Ex: git commit -m "[Chore] - to fix typo"

	__EOF__
}

function lhs_git_commit_suggestions_with_hint() {
	local lhs_input=$(
		lhs_git_commit_suggestions | peco --query "$LBUFFER" --prompt "Git commit suggestions >"
	)

	# To check it is example.
	if [[ $lhs_input = Ex:* ]]; then
		BUFFER=$(echo "${lhs_input}" | awk -F "Ex:" '{print $2}')
	else
		BUFFER=${lhs_input}
	fi
	CURSOR=$#BUFFER
}
