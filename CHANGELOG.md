# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-12-15

### Added
- 🎯 Initial release with core functionality
- 🔐 Security scanning capabilities with git-secrets Docker integration
- 📦 Docker utilities (MongoDB, MySQL clients, git-secrets image builder)
- 🔧 Git utilities (peco-based tools for interactive selection)
- 🗄️ Terraform utilities
- ☸️ Kubernetes utilities
- 🎪 Service utilities (CI/CD, console editors, cURL, Git, Jenkins)
- 🔒 Security policy and documentation (SECURITY.md)
- ✅ Automated CI/CD pipeline with secret detection, shellcheck, and formatting checks
- 📋 Pre-commit hooks for local development security

### Security
- 🔐 Gitleaks integration for secret detection
- 🐚 Shellcheck validation for all shell scripts
- 🎨 Code formatting standardization with shfmt
- 📝 Pre-commit hooks for preventing credential leaks
- 📖 Comprehensive security policy in SECURITY.md

### Documentation
- 📚 Complete README with setup instructions
- 🔒 SECURITY.md with vulnerability reporting guidelines
- 📖 Inline documentation in functions
- 💡 Usage examples for all major functions

### Quality
- ✅ Shell script linting and validation
- 🎨 Consistent code formatting
- 📋 Pre-commit configuration for development
- 🔄 GitHub Actions CI/CD pipeline

---

## Versioning Policy

- **v0.x.y**: Pre-release versions with potential breaking changes
- **v1.0.0+**: Stable versions following semantic versioning
- All releases are tagged with Git tags and available via Homebrew

## Security Updates

For security-related changes and updates, please see [SECURITY.md](SECURITY.md).

## Contributing

Before contributing, please review:
1. [SECURITY.md](SECURITY.md) - Security policies
2. [README.md](README.md) - Project overview
3. Our CI/CD checks run automatically on pull requests

## Support

For issues or questions:
1. Check existing issues and discussions
2. Review [SECURITY.md](SECURITY.md) for security concerns
3. See GitHub Actions logs for CI/CD failures
