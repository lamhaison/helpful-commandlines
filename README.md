# helpful-commandlines
This is the repo to collect helpful commandlines that is used for mac and linux os.


## Setup dependencies
Notes: This document is for macos environment.

### Install gitlab cli
```
brew install glab
export GITLAB_TOKEN=xxxxx
```

### Install Github cli
```
brew install gh
export GH_TOKEN=xxxx
```

### Install peco
To allow searching by console.
![image](./images/peco_history_menu.png)

```
brew install peco
peco --version
peco version v0.5.10 (built with go1.19.2)
```

### Install jq
```
brew install jq
jq --version
jq-1.6
```

## Settings when open terminal (I am using iterm)
```
mkdir -p /opt/lamhaison-tools && cd /opt/lamhaison-tools
git clone https://github.com/lamhaison/helpful-commandlines.git
echo "source /opt/lamhaison-tools/helpful-commandlines/main.sh" >> ~/.bashrc
```

# How to search commandline
```
Ctrl + H or lhs_help_helpful

```

# How to enable git commit suggestions
```
Option + gc or lhs_git_commit_suggestions | peco
```

