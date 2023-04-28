#!/bin/bash

function lhs_tf_enable_debug_mode() {
	export TF_LOG=TRACE
}

function lhs_tf_disable_debug_mode() {
	unset TF_LOG
}
