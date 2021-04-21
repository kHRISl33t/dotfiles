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
alias kcm='kubectl -n monitoring'
alias kci='kubectl -n istio-system'
alias kcdef='kubectl -n default'
alias kcsgp='kubectl -n staging get pod'
alias kcsgpw='kubectl -n staging get pod -w'
alias kceis='kubectl -n staging exec -it'
alias kcsl='kubectl -n staging logs'
alias kcsed='kubectl -n staging edit deployment'
alias kccuc='kubectl config use-context'
alias kccgc='kubectl config current-context'
alias kcgvs='kubectl get virtualservices'
alias kcggw='kubectl get gateways'
alias kcgdr='kubectl get destinationrules'
alias kcsetns="kubectl config set-context --current --namespace"
alias kcgc="kubectl config get-contexts"
alias kcsc="kubectl config set-context"

export NVM_DIR="$USER_PATH_OSX/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
complete -F __start_kubectl kc rkc pkc
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f "/Users/$USER/google-cloud-sdk/path.zsh.inc" ]; then . "/Users/$USER/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "/Users/$USER/google-cloud-sdk/completion.zsh.inc" ]; then . "/Users/$USER/google-cloud-sdk/completion.zsh.inc"; fi

# brew update && brew install kube-ps1
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PS1="$PS1$(kube_ps1) "
