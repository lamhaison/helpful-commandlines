#!/bin/bash

function lhs_jenkins_load_helpful_commandlines() {
	for script in $(find ${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS:-~/lamhaison-tools/helpful-commandlines} -type f -name '*.sh' | grep -v main.sh); do source $script; done
}

function lhs_jenkins_create_release_version_file() {
	VERSION_FILE=./release.txt
	release_time=$(date '+%Y-%m-%d %H:%M:%S')
	echo "release_hash: ${GIT_COMMIT}" >${VERSION_FILE}
	echo "released_at: ${release_time}" >>${VERSION_FILE}
	cat ${VERSION_FILE}
}
