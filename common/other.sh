#!/bin/bash

function lhs_help_install_macos_clipboard_instruction() {
	cat <<-_EOF_
		Install clipy
		Access Shift + command + v
	_EOF_
}

function lhs_help_install_macos_peco_instruction() {
	cat <<-_EOF_
		# Install peco
		brew install peco
	_EOF_

}

function lhs_help_hotkey_sublime_search_files_instruction() {
	cat <<-_EOF_
		# Search file in sublimetext on macos
		⌘(Command) + P
	_EOF_
}

lhs_help_create_os_user_instruction() {

	echo '

		visudo
		son.lam ALL=(ALL) ALL
		# Define variable
		user_name=son.lam
		sudo_password=xxxx
		public_key="ssh-rsa AAAAB3Nza... ${user_name}"
		useradd ${user_name}

		# Sudo to root account
		echo -e "${user_name}\n${user_name}" | (passwd ${user_name})
		su lhs
		mkdir ~/.ssh
		chmod 700 ~/.ssh
		echo "${public_key}" > ~/.ssh/authorized_keys
		chmod 400 -R ~/.ssh/authorized_keys
		exit

	'
}
