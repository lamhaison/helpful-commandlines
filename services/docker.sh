function lamhaison_docker_run_mongodb_client() {
	echo "\
		docker run -ti --rm mongo:5.0.10 bash
		Running [mongosh endpoint]
		
	"
	docker run -ti --rm mongo:5.0.10 bash
}
