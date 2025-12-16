#!/bin/bash
#
# @version 		1.0
# @script		docker.sh
# @description	TODO : docker functions such as build images, ...
#
##

function lhs_docker_build_git_secret_image() {
    local image_name="gitsecrets"
    docker build -t ${image_name} - <<- EOF
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

		# Generic API keys and tokens with common prefixes (32+ alphanumeric characters)
		RUN git secrets --add --global "(api[_-]?key|apikey|token|secret|access[_-]?token)[=:\"' ]+[a-zA-Z0-9]{32,}"

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
    echo "🛠️ Install hooks: docker run -v \$(pwd):/repository ${image_name} git secrets --install"
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
        scan_path="$(cd "$scan_path" 2> /dev/null && pwd)" || {
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
        echo "  • Create .gitallowed file to handle false positives"
        echo "  • Scan again: lhs_docker_scan_secrets"
    fi

    return $exit_code
}

# End of file
