function lamhaison_help_get_public_ip() {
	echo "
		dig +short myip.opendns.com @resolver1.opendns.com
	"

}

function lamhaison_get_public_ip() {
	dig +short myip.opendns.com @resolver1.opendns.com
}
