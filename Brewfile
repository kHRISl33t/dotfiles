# Brewfile
#
# Install everything with:
#   brew bundle install --file=Brewfile
#
# Check what is missing without installing:
#   brew bundle check --file=Brewfile --verbose
#
# Two groups below. The first is what Homebrew currently manages on the machine
# this was captured from. The second is software that IS installed there but was
# added by hand (downloaded .dmg or .pkg), listed as casks so a fresh machine can
# get it in one command instead.

# ---------------------------------------------------------------------------
# Currently managed by Homebrew
# ---------------------------------------------------------------------------

# Shell and terminal
brew "zsh"
brew "tmux"
brew "terminal-notifier"   # macOS notifications from the CLI, used by the tmux hooks
brew "htop"

# Version control and GitHub
brew "gh"

# Data wrangling
brew "jq"                  # JSON
brew "yq"                  # YAML

# Databases
brew "mongocli"
brew "mongodb-atlas-cli"
brew "mysql-client"        # client only, no server

# Cloud and networking
brew "awscurl"             # curl with AWS SigV4 signing, for IAM-authed APIs
brew "caddy"
brew "mkcert"              # locally trusted dev certificates
brew "nmap"

# Media
brew "imagemagick"

# Containers (CLI only, see docker-desktop below for the app)
brew "docker"
brew "docker-compose"

cask "font-hack-nerd-font" # the terminal font, required by the agnoster prompt
cask "mongodb-compass"
cask "ngrok"

# ---------------------------------------------------------------------------
# Installed by hand on the source machine, available as casks
# ---------------------------------------------------------------------------
#
# These are present in /Applications but not tracked by Homebrew there. On a new
# machine, installing them from here means updates come through `brew upgrade`.
# Uninstall the manual copy first if you switch to the cask.

cask "iterm2"
cask "visual-studio-code"
cask "docker-desktop"      # also provides the bundled kubectl
cask "slack"
cask "brave-browser"
cask "1password"
cask "spotify"
cask "vlc"
cask "grammarly-desktop"

# ---------------------------------------------------------------------------
# Deliberately not here
# ---------------------------------------------------------------------------
#
# nvm            installed via its own script so it can manage itself, see the
#                root README. The Homebrew formula exists but fights the
#                standard installer layout.
# node, npm, pnpm  installed through nvm, not Homebrew.
# oh-my-zsh      installed via its own script.
# tpm            git clone, see tmux/README.md
# awscli         the source machine uses the official pkg installer at
#                /usr/local/bin/aws. Add `brew "awscli"` if you prefer Homebrew,
#                but remove the pkg version first or you get two on PATH.
# Company MDM software (security agents, self-service portals) is pushed by the
# employer and must not be installed by hand.
