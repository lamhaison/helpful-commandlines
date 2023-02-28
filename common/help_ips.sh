function lhs_network_get_public_ip_instruction() {
	echo "
		dig +short myip.opendns.com @resolver1.opendns.com
	"

}

function lhs_network_get_public_ip() {
	dig +short myip.opendns.com @resolver1.opendns.com
}

function lhs_what_is_my_ip() {
	lhs_network_get_public_ip
}
