ZSH_DISABLE_COMPFIX="true"

USER_PATH_OSX="/Users/$USER"

export ZSH="$USER_PATH_OSX/.oh-my-zsh"

ZSH_THEME="robbyrussell"

export EDITOR='code -w'

plugins=(
    git
    colored-man-pages
    zsh-autosuggestions
    zsh-syntax-highlighting
    node
    kubectl
)

source $ZSH/oh-my-zsh.sh

# User configuration

# tmux
alias tmx='tmux'
# source .tmux.config
alias stmx='tmux source-file ~/.tmux.conf'
# attach to the last used session
alias tmxa='tmux a'
# attach to a specific session
alias tmxas='tmux a -t'
# create new tmux session with name
alias tmxns='tmux new -s'
# list of sessions
alias tmxls='tmux ls'

# tmuxinator
alias tmxr='tmuxinator'

# Source .zshrc
alias szsh='source ~/.zshrc'

# docker
alias dc='docker-compose'
alias d='docker'

# git
alias gits='git status'
alias gitaa='git add .'
alias gita='git add'
alias gitc='git commit'

alias gitcm='git checkout master'
alias gitprom='git pull --rebase origin master'
alias gitpro='git pull --rebase origin'
alias gitf='git fetch'
alias gitrm='git rebase master'
alias gitcb='git branch -b'

alias gitcount='git rev-list --count $(git rev-parse --abbrev-ref HEAD)'
alias lslinesnode='git ls-files | grep "\(.js\|.ts\)$" | xargs wc -l'
alias lslinesreact='git ls-files | grep "\(.jsx\|.js\|.css\|.scss\)$" | xargs wc -l'
alias lslinesmono='git ls-files | grep "\(.sh\|.js\|.ts\|.tsx\|.css\|.scss\)$" | xargs wc -l'

# kubectl shortcuts
# https://kubernetes.io/docs/reference/kubectl/cheatsheet/
alias kc='kubectl'
alias kccf='kubectl create -f'
alias kcei='kubectl exec -it'
alias kcgd='kubectl get deployment'
alias kcgp='kubectl get pods'
alias kcgs='kubectl get svc'
alias kcgn='kubectl get nodes'
alias kcgss='kubectl get statefulset'
alias kcgss='kubectl get daemonset'
alias kce='kubectl edit'
alias kcd='kubectl describe'
alias kcl='kubectl logs'
alias kccp='kubectl cp'

alias kccw='kubectl config view'
alias kcrollstatw='kubectl rollout status -w deployment/'
alias kcrollres='kubectl rollout restart deployment/'

# istio specific
alias kcgvs='kubectl get virtualservices'
alias kcggw='kubectl get gateways'
alias kcgdr='kubectl get destinationrules'

# kubens => alias kcsetns="kubectl config set-context --current --namespace"
# kubectx => kubealias kcgc="kubectl config get-contexts"
# kubectx => alias kcsc="kubectl config set-context"

export NVM_DIR="$USER_PATH_OSX/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
complete -F __start_kubectl kc rkc pkc
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f "/Users/$USER/google-cloud-sdk/path.zsh.inc" ]; then . "/Users/$USER/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "/Users/$USER/google-cloud-sdk/completion.zsh.inc" ]; then . "/Users/$USER/google-cloud-sdk/completion.zsh.inc"; fi

# brew update && brew install kube-ps1 && brew install kubectx
# https://github.com/jonmosco/kube-ps1
# https://github.com/ahmetb/kubectx
# kubeon / kubeoff - turn on/off kubecontext/namespace info
source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
PROMPT='$(kube_ps1)'$PROMPT

GOPATH="$USER_PATH_OSX/go"
PATH="$PATH:$GOPATH/bin"

# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi
# alias python=/usr/local/bin/python3.7
# alias pip=/usr/local/bin/pip3

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
