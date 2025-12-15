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
		FROM ubuntu:22.04
		
		# Install dependencies and clean up in single layer
		RUN apt-get update && \
		    apt-get install -y git make && \
		    apt-get clean && \
		    rm -rf /var/lib/apt/lists/*
		
		# Clone and install git-secrets
		RUN git clone https://github.com/awslabs/git-secrets.git && \
		    cd git-secrets && \
		    make install
		
		# Configure git-secrets globally
		RUN git secrets --register-aws --global && \
		    git secrets --install ~/.git-templates/git-secrets && \
		    git config --global init.templateDir ~/.git-templates/git-secrets

		# Add security patterns for common services
		# Slack tokens (xoxp, xoxb, xapp)
		RUN git secrets --add --global "(xoxp|xoxb|xapp)-[0-9]{12}-[0-9]{13}-[a-zA-Z0-9]{24}"
		
		# GitHub tokens (ghp, gho, ghu, ghs, ghr)
		RUN git secrets --add --global "(ghp|gho|ghu|ghs|ghr)_[a-zA-Z0-9]{36}"
		
		# GitLab tokens
		RUN git secrets --add --global "(glpat)-[a-zA-Z0-9\-]{20}"
		
		# NewRelic license keys
		RUN git secrets --add --global "[0-9a-zA-Z]{36}NRAL"
		
		# Generic JWT tokens
		RUN git secrets --add --global "eyJ[a-zA-Z0-9+/]*\.[a-zA-Z0-9+/]*\.[a-zA-Z0-9+/\-_]*"
		
		# Generic API keys (32+ alphanumeric characters)
		RUN git secrets --add --global "[a-zA-Z0-9]{32,}"
		
		# Database connection strings
		RUN git secrets --add --global "(mongodb|mysql|postgres)://[^\\s]*:[^\\s]*@"
		
		# Private keys - using escaped pattern to avoid shell interpretation
		RUN git secrets --add --global "BEGIN.*PRIVATE.*KEY"
		
		# Set working directory and configure safe directory
		WORKDIR /repository
		RUN git config --global --add safe.directory /repository
		
		# Add metadata labels
		LABEL description="Git-secrets scanner with pre-configured security patterns"
		LABEL version="1.0"
		LABEL usage="docker run -v \$(pwd):/repository gitsecrets git secrets --scan"
	EOF
	
	echo "✅ Image '${image_name}' built successfully!"
	echo "📖 Usage: docker run -v \$(pwd):/repository ${image_name} git secrets --scan"
	echo "🔍 Scan current directory: docker run -v \$(pwd):/repository ${image_name} git secrets --scan"
	echo "🛠️  Install hooks: docker run -v \$(pwd):/repository ${image_name} git secrets --install"
	echo "💡 Tip: Run 'lhs_docker_create_gitallowed' to create .gitallowed file for false positives"
}


# Runs git-secrets scan on the current directory or specified files/directories
# Usage: lhs_docker_scan_secrets [path] [options]
# Examples:
#   lhs_docker_scan_secrets                    # Scan current directory
#   lhs_docker_scan_secrets /path/to/project   # Scan specific directory
#   lhs_docker_scan_secrets --history          # Scan git history
#   lhs_docker_scan_secrets --cached           # Scan staged files
function lhs_docker_scan_secrets() {
	local scan_path="${1:-.}"
	local scan_options=""
	local scan_type="directory"
	
	# Parse arguments for special scan types
	case "$1" in
		--history)
			scan_type="history"
			scan_path="${2:-.}"
			;;
		--cached)
			scan_options="--cached"
			scan_path="${2:-.}"
			scan_type="cached"
			;;
		--untracked)
			scan_options="--untracked"
			scan_path="${2:-.}"
			scan_type="untracked"
			;;
		--recursive)
			scan_options="--recursive"
			scan_path="${2:-.}"
			scan_type="recursive"
			;;
		--help)
			echo "🔍 Git-secrets scanner usage:"
			echo ""
			echo "📋 Basic Usage:"
			echo "  lhs_docker_scan_secrets                    # Scan current directory"
			echo "  lhs_docker_scan_secrets /path/to/project   # Scan specific path"
			echo ""
			echo "🎯 Special Scan Types:"
			echo "  lhs_docker_scan_secrets --history          # Scan entire git history"
			echo "  lhs_docker_scan_secrets --cached           # Scan staged files only"
			echo "  lhs_docker_scan_secrets --untracked        # Include untracked files"
			echo "  lhs_docker_scan_secrets --recursive        # Recursive directory scan"
			echo ""
			echo "⚙️ Prerequisites:"
			echo "  • Docker must be installed and running"
			echo "  • Git-secrets image must be built (run lhs_docker_build_git_secret_image)"
			echo ""
			echo "💡 Tips:"
			echo "  • Create .gitallowed file to handle false positives"
			echo "  • Run lhs_docker_create_gitallowed for common exclusions"
			return 0
			;;
	esac
	
	# Check if Docker is available
	if ! command -v docker &> /dev/null; then
		echo "❌ Docker is not installed or not in PATH"
		echo "📥 Please install Docker first"
		return 1
	fi
	
	# Check if git-secrets image exists
	if ! docker image inspect gitsecrets &> /dev/null; then
		echo "❌ Git-secrets Docker image not found"
		echo "🔨 Run 'lhs_docker_build_git_secret_image' to build the image first"
		return 1
	fi
	
	# Convert relative path to absolute path for Docker
	if [[ "$scan_path" != /* ]]; then
		scan_path="$(cd "$scan_path" 2>/dev/null && pwd)" || {
			echo "❌ Path '$scan_path' does not exist"
			return 1
		}
	fi
	
	echo "🔍 Running git-secrets scan..."
	echo "📂 Target: $scan_path"
	echo "🎯 Type: $scan_type"
	echo ""
	
	# Run the appropriate scan command
	local exit_code=0
	if [[ "$scan_type" == "history" ]]; then
		echo "⏳ Scanning git history (this may take a while)..."
		docker run -v "$scan_path:/repository" gitsecrets git secrets --scan-history
		exit_code=$?
	else
		echo "⏳ Scanning files..."
		docker run -v "$scan_path:/repository" gitsecrets git secrets --scan $scan_options
		exit_code=$?
	fi
	
	echo ""
	
	# Interpret results
	if [[ $exit_code -eq 0 ]]; then
		echo "✅ No secrets detected!"
		echo "🎉 Repository appears clean of sensitive data"
	else
		echo "🚨 Secrets detected! (Exit code: $exit_code)"
		echo ""
		echo "🔧 Next steps:"
		echo "  1. Review the files listed above"
		echo "  2. Remove or secure any real secrets"
		echo "  3. Add false positives to .gitallowed file"
		echo "  4. Re-run the scan to verify fixes"
		echo ""
		echo "💡 Quick fixes:"
		echo "  • Create .gitallowed: lhs_docker_create_gitallowed"
		echo "  • Scan again: lhs_docker_scan_secrets"
	fi
	
	return $exit_code
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
	local_lhs_docs_add_prefix 'lhs_docker_docs_build_image_optimized_instruction' 'image'
	local_lhs_docs_add_prefix 'lhs_docker_install_aws_linux_2_instruction' 'install'
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
