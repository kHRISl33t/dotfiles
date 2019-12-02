# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/kristofivancza/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source "/Users/kristofivancza/.oh-my-zsh/custom/themes/spaceship.zsh-theme"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  osx
  nvm
  npm
  node
  minikube
  docker
  cp
  aws
)

SPACESHIP_USER_SHOW=always

# source $ZSH/oh-my-zsh.sh

export EDITOR="code -w"

# kubectl shortcuts

alias kc='kubectl'
alias kccf='kubectl create -f'
alias kcei='kubectl exec -it'
alias kcgd='kubectl get deployment'
alias kcgp='kubectl get pods'
alias kcgs='kubectl get svc'
alias kcgn='kubectl get nodes'
alias kce='kubectl edit'
alias kcd='kubectl describe'
alias kccl='kubectl logs'
alias kccp='kubectl cp'
alias kcks='kubectl -n kube-system'
alias kcs='kubectl -n staging'
alias kcp='kubectl -n prod'
alias kcsgp='kubectl -n staging get pod'
alias kcsgpw='kubectl -n staging get pod -w'
alias kceis='kubectl -n staging exec -it'
alias kcsl='kubectl -n staging logs'
alias kcsed='kubectl -n staging edit deployment'
alias kccuc='kubectl config use-context'
alias kccgc='kubectl config current-context'
alias kcm='kubectl -n monitoring'
alias kci='kubectl -n istio-system'
alias kcgvs='kubectl get virtualservices'
alias kcggw='kubectl get gateways'
alias kcgdr='kubectl get destinationrules'

# git shortcuts

alias gitca='git commit -am'
alias gitaa='git add -A'
alias gits='git status'

alias gitcm='git checkout master'
alias gitprom='git pull --rebase origin master'
alias gitpro='git pull --rebase origin'
alias gitf='git fetch'
alias gitrm='git rebase master'
alias gitcb='git branch -b'

# docker

alias d='docker'
alias dc='docker-compose'

alias myproj='cd /home/kristofivancza/development/my-projects'

# kubectl auto-completion

source <(kubectl completion zsh)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kristofivancza/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kristofivancza/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kristofivancza/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kristofivancza/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
