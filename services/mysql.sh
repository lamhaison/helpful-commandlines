#!/bin/bash

function lamhaison_mysql_dump_db {
	echo '
		db_username=
		db_password=
		db_address=
		db_name=
		mysqldump --skip-lock-tables -u ${db_username} -p${db_password} \
			-h ${db_address} ${db_name} > ${db_name}-$(date "+%Y-%m-%d-%H-%M-%S").sql
	'
}
