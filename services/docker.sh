function lhs_docker_run_mongodb_client() {
	echo "\
		docker run -ti --rm mongo:5.0.10 bash
		Running [mongosh endpoint]
		
	"
	docker run -ti --rm mongo:5.0.10 bash
}

function lhs_docker_run_mysql_client_57() {

	echo "\
		docker run -it --rm -v /tmp/dump:/dump mysql:5.7 /bin/bash

		Running commandline to dump data
		mysqldump -u <user> -h <host> -p <db_name> > /dump/<backdup_date>.sql
		
	"
	docker run -it --rm -v /tmp/dump:/dump mysql:5.7 /bin/bash
}
