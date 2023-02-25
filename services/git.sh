#!/bin/bash

function lhs_git_list_branches() {
	git fetch origin
	git branch -r
}
function lhs_git_list_tags() {
	git fetch --all
	git tag -l --sort=v:refname | grep "v" | sort -r
}

function lhs_git_list_tags_with_hint() {
	input_project=$(lhs_peco_repo_list)
	cd ${input_project} && lhs_git_list_tags
}

function lhs_git_create_tag() {
	tag_version=$1
	git checkout master
	git fetch
	git pull origin master
	git checkout tags/${tag_version}
	# git diff --name-only v1.0.2 v1.0.3
}

function lhs_project_get() {
	input_project=$(lhs_peco_repo_list)
	cd ${input_project}
}

# https://cli.github.com/manual/
function lhs_github_repo_list() {
	local git_owner=$1
	gh repo list ${git_owner:?'git_owner is unset or empty'} \
		--visibility private --json name --jq '.[].name'
}

function lhs_github_repo_list_sshurl() {
	local git_owner=$1
	gh repo list ${git_owner:?'git_owner is unset or empty'} \
		--visibility private --json sshUrl --jq '.[].sshUrl'
}

function lhs_github_repo_list_url() {
	local git_owner=$1
	gh repo list ${git_owner:?'git_owner is unset or empty'} \
		--visibility private --json url --jq '.[].url'
}

function lhs_github_repo_get_collaborators() {
	local git_repo_name=$1
	# echo "Get collaborators of the repo ${git_repo_name}"
	gh api -H "Accept: application/vnd.github+json" \
		/repos/${git_repo_name:?'git_repo_name is unset or empty'}/collaborators
}

function lhs_github_repo_clone() {
	local git_repo_name=$1
	gh repo clone ${git_repo_name:?'git_repo_name is unset or empty'}
}

function lhs_github_clone_all() {
	local owner_list=${1}
	for owner in $(echo ${owner_list:?'owner_list is unset or empty'}); do
		mkdir -p ${LHS_PROJECTS_DIR}/${owner}
		cd ${LHS_PROJECTS_DIR}/${owner}
		for repo in $(lhs_github_repo_list ${owner}); do
			lhs_github_repo_clone "${owner}/${repo}"
		done
	done
}

function lhs_github_clone_all_by_sshgit() {
	local owner_list=${1}
	for owner in $(echo ${owner_list:?'owner_list is unset or empty'}); do
		mkdir -p ${LHS_PROJECTS_DIR}/${owner}
		cd ${LHS_PROJECTS_DIR}/${owner}
		for repo in $(lhs_github_repo_list_sshurl ${owner}); do
			git clone $repo
		done
	done
}

function lhs_git_set_pull_rebase() {
	git config pull.rebase true
}

function lhs_git_list_commits() {
	git log --oneline
}

function lhs_git_list_new_files() {
	git ls-files --others --exclude-standard
}

function lhs_git_change_comment_the_latest_commit() {
	local git_new_comment=$(echo "${1:=New commit message.}")
	echo "git commit --amend -m \"${git_new_comment}\""
}

# Git commit

function lhs_git_diff() {
	lhs_run_commandline "git diff --name-only"

}

function lhs_git_commit() {
	local lhs_git_commit_cmd=$(echo "git add ${1:=*}")
	lhs_git_diff
	lhs_run_commandline "${lhs_git_commit_cmd}"
	lhs_git_diff

}

function lhs_git_commit_with_hint() {
	lhs_git_file_name=$(lhs_peco_create_menu 'lhs_peco_git_diff_name_only')
	lhs_git_un_modify_the_file ${lhs_git_file_name}
}

function lhs_git_un_commit_the_file() {
	lhs_commandline_logging "git reset HEAD ${1}"
	git reset HEAD $1
}

function lhs_git_un_modify_the_file() {
	lhs_commandline_logging "git checkout ${1}"
	git checkout ${1:?'lhs_git_file_name is unset or empty'}
}

function lhs_git_un_modify_the_file_with_hint() {

	# TODO Later
	lhs_peco_git_diff_name_only() {
		lhs_peco_commandline_input 'git diff --name-only'
	}

	lhs_git_file_name=$(lhs_peco_create_menu 'lhs_peco_git_diff_name_only')
	lhs_git_un_modify_the_file ${lhs_git_file_name}
}
function lhs_git_un_commit_the_file_instruction() {
	cat <<__EOF__
	let’s say you’ve changed two files and want to commit them as two separate changes, but you accidentally type git add * and stage them both.
	git reset HEAD path/to/file
__EOF__
}

function lhs_git_commit_forgot_change_files_instruction() {
	cat <<__EOF__
	If you commit and then realize you forgot to stage the changes in a file you wanted to add to this commit, 
	you can do something like this:
		+ git commit -m 'initial commit'
		+ git add forgotten_file
		+ git commit --amend
		+ You end up with a single commit—the second commit replaces the results of the first.
__EOF__
}

function lhs_git_comment_instruction() {
	cat <<-__EOF__
		More instruction - https://www.freecodecamp.org/news/how-to-write-better-git-commit-messages/
		                 - https://chiamakaikeanyi.dev/how-to-write-good-git-commit-messages/
		Set default git commit message - https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration

		git commit -m "[Add] - Your add description"
		git commit -m "[Refactor] - Your Refactor description"
		git commit -m "[Fix] - Your fixing bugs detail"
		git commit -m "[Debug] - Your debuging detail"
		git commit -m "[Document] - Your Document description"
		git commit -m "[Remove] - Your remove detail"

		git commit -m "[Release] - Your Release description (Comment for the PR)"
	__EOF__
}
