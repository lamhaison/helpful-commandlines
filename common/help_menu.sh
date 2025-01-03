#!/bin/bash

function lhs_help_helpful() {
	# Support both function function_name() { or function_name with prefix aws_bla_bla() {
	local lhs_functions=$(lhs_peco_helpful_function_list)
	local lhs_option=${1:-IgnoreCase}

	BUFFER=$(
		echo "${lhs_functions}" | peco --query "$LBUFFER" --initial-filter "${lhs_option}"
	)
	CURSOR=$#BUFFER

}

function lhs_help_all() {
	# Support both function function_name() { or function_name with prefix aws_bla_bla() {
	# shellcheck disable=SC2155
	local lhs_functions=$(lhs_peco_function_list)
	local lhs_option=${1:-"${LHS_PECO_FILTER_TYPE}"}
	BUFFER=$(
		echo "${lhs_functions}" | peco --query "$LBUFFER" --initial-filter "${lhs_option}"
	)
	CURSOR=$#BUFFER

}

function lhs_help_refresh() {
	lhs_peco_disable_input_cached
	lhs_peco_function_list >>/dev/null
	lhs_peco_helpful_function_list >>/dev/null
	lhs_peco_enable_input_cached

}
