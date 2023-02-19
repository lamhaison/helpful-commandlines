#!/bin/bash

function lhs_ci_laravel_replace_aws_credentials_in_env_file() {
	APP_ENV=$1
	OLD_AWS_ACCESS_KEY_ID=$2
	NEW_AWS_ACCESS_KEY_ID=$3
	OLD_AWS_SECRET_ACCESS_KEY=$4
	NEW_AWS_SECRET_ACCESS_KEY=$5
	cat .env.${APP_ENV} | sed "s/${OLD_AWS_ACCESS_KEY_ID}/${NEW_AWS_ACCESS_KEY_ID}/g" | sed "s/${OLD_AWS_SECRET_ACCESS_KEY}/${NEW_AWS_SECRET_ACCESS_KEY}/g"

}
