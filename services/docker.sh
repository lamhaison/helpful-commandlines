#!/bin/bash
#
# @version 		1.0
# @script		docker.sh
# @description	TODO : docker functions such as build images, ...
#
##

function lhs_docker_install_aws_linux_2_instruction() {
	cat <<-__EOF__
		sudo amazon-linux-extras install -y docker
		sudo service docker start
		sudo usermod -a -G docker ec2-user
		sudo chkconfig docker on
		sudo yum install -y git
		sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-\$(uname -s)-\$(uname -m) -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
		echo 'export PATH="/usr/local/bin:\$PATH"' >> ~/.bash_profile
		source ~/.bash_profile
		docker-compose version
	__EOF__
}

function lhs_docker_upgrade_ubuntu_instruction() {
	local lhs_docs=$(
		cat <<-__EOF__
			https://docs.docker.com/engine/install/ubuntu/
		__EOF__
	)
	echo "$lhs_docs"
}

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

function lhs_docker_build_git_secret_image() {
	local image_name="gitsecrets"
	docker build -t ${image_name} - <<-EOF
		FROM ubuntu:20.04
		RUN apt update && apt install -y git make
		RUN git clone https://github.com/awslabs/git-secrets.git
		WORKDIR /git-secrets
		RUN make install
		RUN git secrets --register-aws --global && \
		    git secrets --install ~/.git-templates/git-secrets && \
		    git config --global init.templateDir ~/.git-templates/git-secrets

		# Adds a prohibited pattern to the global git config
		# Slack
		RUN git secrets --add --global "(xoxp|xoxb|xapp)-[0-9]{12}-[0-9]{13}-[a-zA-Z0-9]{24}" 
		# Github token
		RUN git secrets --add --global "(ghp)_[a-zA-Z0-9]{36}" 
		# Gitlab token
		RUN git secrets --add --global "(glpat)-[a-zA-Z0-9\-]{20}"

		# Jenkins token
		RUN git secrets --add --global "[a-zA-Z0-9]{32}"

		# Backlog token
		RUN git secrets --add --global "[a-zA-Z0-9]{64}"

		# AWS account id such as 123456789123
		RUN git secrets --add --global "^[0-9]{12}$"

		# NewRelic
		RUN git secrets --add --global "[0-9a-zA-Z]{36}NRAL"

		# Git allow pattern
		RUN git secrets --add --global --allowed '(8fe7937f147a6cb0ed446ef3ac17f972|da04f0c3b2a114f952bac215d3808223)'
		WORKDIR /repository
		RUN git config --global --add safe.directory /repository
	EOF

}

function lhs_docker_docs_build_image_optimized_instruction() {

	local lhs_docs=$(
		cat <<-__EOF__
			Use minimal base images
			Use multistage builds
			Use Dockerignore
			Double-check the dependencies
			Minimize the image layers
		__EOF__
	)

	echo "${lhs_docs}"
}

function lhs_docker_analyze_docker_image_instruction() {

	local lhs_docs=$(
		cat <<-__EOF__
			brew install dive # Install dive to analyze docker image
			open "https://github.com/wagoodman/dive" # Open dive document
			dive <image_name> # Analyze docker image
		__EOF__
	)
	echo "${lhs_docs}"
}

function lhs_docker_docs_all() {
	lhs_docs_add_prefix 'lhs_docker_docs_build_image_optimized_instruction' 'image'
	lhs_docs_add_prefix 'lhs_docker_install_aws_linux_2_instruction' 'install'
}

function lhs_docker_alpine_install_telnet_instruction() {

	local lhs_docs=$(
		cat <<-__EOF__
			apk update
			apk add busybox-extras
		__EOF__
	)

	echo "$lhs_docs"
}
