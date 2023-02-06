#!/bin/bash

function lamhaison_help_install_macos_clipboard() {
	cat <<-_EOF_
		Install clipy
		Access Shift + command + v
	_EOF_
}

function lamhaison_help_install_macos_peco() {
	cat <<-_EOF_
		# Install peco
		brew install peco
	_EOF_

}

function lamhaison_help_hotkey_sublime_search_files() {
	cat <<-_EOF_
		# Search file in sublimetext on macos
		⌘(Command) + P
	_EOF_
}

function lamhaison_git_tag_list() {
	git fetch --all
	git tag -l --sort=v:refname | grep "v" | sort -r
}

function lamhaison_git_tag_list_with_hint() {
	input_project=$(peco_repo_list)
	cd ${input_project} && lamhaison_git_tag_list
}

function lamhaison_git_tag_create() {
	tag_version=$1
	git checkout master
	git fetch
	git pull origin master
	git checkout tags/${tag_version}
	# git diff --name-only v1.0.2 v1.0.3
}
