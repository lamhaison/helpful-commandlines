#!/bin/bash

function lhs_jenkins_load_helpful_commandlines() {
	for script in $(find ${HELPFUL_COMMANDLINES_SOURCE_SCRIPTS:="~/lamhaison-tools/helpful-commandlines"} -type f -name '*.sh' | grep -v main.sh); do source $script; done
}
