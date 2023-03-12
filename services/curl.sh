#!/bin/bash

function lhs_curl_get_response_headers_only() {

	lhs_curl_url=${1:-'https://devopsmountain.com'}
	echo "\
		http_endpoint: ${lhs_curl_url}
		-s hides the progress bar
		-D - dump headers to stdout indicated by -
		-o /dev/null send output (HTML) to /dev/null essentially ignoring it
	"

	curl -s -D - -o /dev/null ${lhs_curl_url}
}
