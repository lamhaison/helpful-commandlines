#!/bin/bash

function lhs_ci_laravel_replace_aws_credentials_in_env_file() {
	local APP_ENV=$1
	local OLD_AWS_ACCESS_KEY_ID=$2
	local NEW_AWS_ACCESS_KEY_ID=$3
	local OLD_AWS_SECRET_ACCESS_KEY=$4
	local NEW_AWS_SECRET_ACCESS_KEY=$5
	cat .env.${APP_ENV} |
		sed "s|${OLD_AWS_ACCESS_KEY_ID}|${NEW_AWS_ACCESS_KEY_ID}|g" |
		sed "s|${OLD_AWS_SECRET_ACCESS_KEY}|${NEW_AWS_SECRET_ACCESS_KEY}|g" \
			>.env.${APP_ENV}_tmp

}

function lhs_ci_laravel_overwrite_aws_credentials_in_env_file() {
	local APP_ENV=$1
	rm -rf .env.${APP_ENV}
	mv .env.${APP_ENV}_tmp .env.${APP_ENV}
}

function lhs_ci_laravel_rm_aws_credentials_in_env_file() {
	local APP_ENV=$1
	rm -rf .env.${APP_ENV}
}

function lhs_ci_laravel_delete_aws_credentials_in_env_file() {
	local APP_ENV=$1
	rm -rf .env.${APP_ENV}
}
