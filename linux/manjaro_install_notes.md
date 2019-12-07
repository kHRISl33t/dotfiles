```sh
# etcher - bootable pendrive creator
yay -S etcher

sudo pacman-mirrors --geoip && sudo pacman -Syyuu

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

sudo pacman -S snapd
sudo systemctl enable --now snapd.socket

sudo pacman -S tmux
yay -S latte-dock
sudo pacman -S kdecoration qt5-declarative qt5-x11extras
sudo pacman -S cmake extra-cmake-modules
# customize theme and appearance https://www.youtube.com/watch?v=uyz4-KZOzyI

yay -S nerd-fonts-hack
sudo pacman -S zsh
# change default shell to zsh
# a logout is required to see it worked or not!
# usually the oh-my-zsh install script is setting the default shell to zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)

# zsh syntax highlight plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh auto suggestion
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

yay -S slack-desktop
yay -S google-chrome
yay -S spotify
sudo pacman -S albert
yay -S visual-studio-code-bin
yay -S postman-bin
yay -S insomnia

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | zsh
nvm install 12.13.0

sudo pacman -S docker
sudo pacman -S docker-compose

sudo systemctl start docker
sudo systemctl enable docker

# add docker command to your user, so you dont have to use `sudo docker`
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
# run docker ps | docker info to verify it works

# enpass
yay -S enpass-bin

# install gcloud cli and kubectl
https://cloud.google.com/sdk/docs/quickstart-linux
gcloud components install kubectl

# generate ssh keys

# evernote for linux
yay -S tusk

# active apple keyboard function keys
sudo nano /sys/module/hid_apple/parameters/fnmode
# if value is 1 edit it to 2

# to make it permanent edit /etc/modprobe.d/hid_apple.conf
options hid_apple fnmode=2
options hid_apple swap_opt_cmd=1

# remapping keys, detect events
yay -S xev

# Make right CMD and ALT as Home and End
keycode 108 = Home NoSymbol Home
keycode 134 = End NoSymbol End
# Make F12 and Eject as Up and Down
keycode 96 = Down NoSymbol Down
keycode 169 = Up NoSymbol Up

# tmuxinator
sudo pacman -S ruby
gem install tmuxinator

# put this in your .zshrc
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

```