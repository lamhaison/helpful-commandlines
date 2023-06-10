function lhs_network_get_public_ip_instruction() {
	echo "
		dig +short myip.opendns.com @resolver1.opendns.com
	"

}

function lhs_network_get_public_ip() {
	dig +short myip.opendns.com @resolver1.opendns.com
}

function lhs_network_tcp_traceroute() {

	# https://www.redhat.com/sysadmin/traceroute-finding-meaning
	sudo tcptraceroute 8.8.8.8 443
}
