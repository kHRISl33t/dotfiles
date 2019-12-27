export ZSH="/home/kristofivancza/.oh-my-zsh"

ZSH_THEME="agnoster"

export EDITOR='code -w'

plugins=(
    archlinux
    git
    history-substring-search
    colored-man-pages
    zsh-autosuggestions
    zsh-syntax-highlighting
    node
    kubectl
)

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# # Remap keys using Xmodmap
# xmodmap $HOME/.Xmodmap
# # TEMP SOLUTION TO LOAD XMODMAP WHEN USING EXTERNAL KEYBOARD

source /home/kristofivancza/.gem/ruby/2.6.0/gems/tmuxinator-1.1.3/completion/tmuxinator.zsh


# tmux
alias tns='tmux new-session -t'
alias tas='tmux attach-session -t'
alias tmuxls='tmux ls'

# Source .zshrc
alias updatezsh='source ~/.zshrc'

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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/kristofivancza/google-cloud-sdk/path.zsh.inc' ]; then . '/home/kristofivancza/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/kristofivancza/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/kristofivancza/google-cloud-sdk/completion.zsh.inc'; fi

# xsel

alias pbcopy="xsel --clipboard --input"
alias pbpaste="xsel --clipboard --output" 

# ruby
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

alias lslinesnode="git ls-files | grep "\(.js\|.ts\)$" | xargs wc -l"
alias lslinesreact="git ls-files | grep "\(.jsx\|.js\|.css\|.scss\)$" | xargs wc -l"
