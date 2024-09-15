#!/bin/bash

###################################################################
# # @script			help_ips.sh
# # @author		 	lamhaison
# # @email		 	lamhaison@gmail.com
###################################################################

# shellcheck disable=SC2148
function lhs_network_get_public_ip_instruction() {
	echo "
		dig +short myip.opendns.com @resolver1.opendns.com
	"

}

function lhs_network_get_private_ip_ranges_instruction() {

	# shellcheck disable=SC2155
	local lhs_docs=$(
		cat <<-__EOF__
			     10.0.0.0        -   10.255.255.255  (10/8 prefix)
			     172.16.0.0      -   172.31.255.255  (172.16/12 prefix)
			     192.168.0.0     -   192.168.255.255 (192.168/16 prefix)
		__EOF__
	)

	echo "$lhs_docs"
}

function lhs_network_get_public_ip() {
	dig +short myip.opendns.com @resolver1.opendns.com
}

function lhs_network_tcp_traceroute() {

	# https://www.redhat.com/sysadmin/traceroute-finding-meaning
	sudo tcptraceroute 8.8.8.8 443
}
