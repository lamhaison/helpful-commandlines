#!/bin/bash

function lhs_code_commment_instruction() {
	cat <<-__EOF__
		* For the task will be fixed later. Comment # TODO Later
	__EOF__
}

function lhs_vi_set_commandlines_instruction() {
	cat <<-_EOF_
		: set nu
		: set nu! or :set nonu
	_EOF_
}
