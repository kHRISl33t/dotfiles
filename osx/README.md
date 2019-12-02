# Install chrome

- https://www.google.com/chrome/

# Docker for mac

- https://docs.docker.com/docker-for-mac/install/

# Install iTerm

- https://www.iterm2.com/

# Install vscode

- https://code.visualstudio.com/docs/setup/mac

# Install 1pw and enpass

- Search for both in the App store

# Install Homebrew and zsh

```sh
# Install homebrew
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install zsh
$ brew install zsh

# (optional) set default shell
$ chsh -s /bin/zsh

# Verify, open new terminal
$ echo $SHELL
```

# Install oh-my-zsh and spaceship theme

- https://github.com/robbyrussell/oh-my-zsh

- `npm install -g spaceship-zsh-theme`

# Install nvm

https://nodesource.com/blog/installing-node-js-tutorial-using-nvm-on-mac-os-x-and-ubuntu/

Add this to .zshrc to make sure nvm is working

```sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

# Install gcloud cli and kubectl

```sh
$ curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl

OR

$ brew install kubernetes-cli
$ kubectl version
```

- https://cloud.google.com/sdk/docs/quickstart-macos
