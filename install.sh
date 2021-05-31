#!/bin/bash
#############################################################################################################
#                                       __  _| | | __ _ _   _  ___ __ _                                     #
#                                       \ \/ | | |/ _` | | | |/ __/ _` |                                    #
#                                        >  <| | | (_| | |_| | (_| (_| |                                    #
#                                       /_/\_|_|_|\__,_|\__,_|\___\__,_|                                    #
#############################################################################################################
#############################################################################################################
#                                              VARIABLES FOR COLORS                                         #
#############################################################################################################
verde="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
rojo="\e[0;31m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
morado="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
gris="\e[0;37m\033[1m"
echo -e "\n${verde}[INICIANDO...]${endColour}\n"
#############################################################################################################
#                                                INSTALACION DE DEPENDECIAS                                 #
#############################################################################################################
cd ~
sudo chsh -s /bin/zsh root
sudo pacman -S feh --noconfirm #
sudo pacman -S wget --noconfirm
sudo pacman -S xmonad xmonad-contrib --noconfirm
sudo pacman -S xmobar --noconfirm
sudo pacman -S compton --noconfirm
sudo pacman -S lolcat --noconfirm
#setting-up lolcat
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"
gem list
gem update
gem install lolcat
#
sudo pacman -S xclip --noconfirm
sudo pacman -S neofetch --noconfirm
sudo pacman -S zsh-syntax-highlighting --noconfirm
sudo pacman -S zsh-autosuggestions --noconfirm
sudo pacman -S nano-syntax-highlighting --noconfirm
sudo pacman -S fzf --noconfirm
#############################################################################################################
#                                                  FOLDERS CREATION                                         #
#############################################################################################################
cd ~/dotfiles
mkdir -p ~/.config/dotfiles
mkdir -p ~/.config/dotfiles/xmobar
mkdir -p ~/.config/dotfiles/scripts
mkdir -p ~/.config/dotfiles/backgrounds
mkdir -p ~/.config/dotfiles/icons
mkdir -p ~/.config/dotfiles/picom
cp xmonad/xmonad.hs ~/.xmonad/xmonad.hs
cp xmobar/xmobarrc  ~/.config/dotfiles/xmobar/xmobarrc
cp scripts/autostart.sh ~/.config/dotfiles/scripts/autostart.sh
cp scripts/ethernet_status.sh ~/.config/dotfiles/scripts/ethernet_status.sh
cp scripts/hackthebox.sh ~/.config/dotfiles/scripts/hackthebox.sh
cp backgrounds/sami.jpg ~/.config/dotfiles/backgrounds/sami.jpg
cp backgrounds/aphack.jpg ~/.config/dotfiles/backgrounds/aphack.jpg
cp icons/haskell_20.xpm ~/.config/dotfiles/icons/haskell_20.xpm
cp neofetch/config.conf ~/.config/neofetch/config.conf
cp picom/picom.conf ~/.config/dotfiles/picom/picom.conf
chmod +x ~/.config/dotfiles/scripts/autostart.sh
chmod +x ~/.config/dotfiles/scripts/ethernet_status.sh
chmod +x ~/.config/dotfiles/scripts/hackthebox.sh
#############################################################################################################
#                                                plugins installation                                       #
#############################################################################################################
cd ~
sudo wget -N https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -O /usr/share/zsh/plugins/zsh-autosuggestions/sudo.plugin.zsh
#sudo chmod +x /usr/share/zsh/plugins/zsh-autosuggestions/sudo.plugin.zsh
#install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
#install tmux
cd ~
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
#install vmtools
sudo pacman -S open-vm-tools --noconfirm
sudo systemctl enable vmtoolsd
sudo systemctl start vmtoolsd
#paso final
reboot
