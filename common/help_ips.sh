function lhs_help_get_public_ip() {
	echo "
		dig +short myip.opendns.com @resolver1.opendns.com
	"

}

function lhs_get_public_ip() {
	dig +short myip.opendns.com @resolver1.opendns.com
}
