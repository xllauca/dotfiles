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
username=$(whoami)
echo -e "\n${verde}[INICIANDO...]${endColour}\n"
#############################################################################################################
#                                            INSTALLING DEPENDENCIES                                        #
#############################################################################################################
echo -e "\n${amarillo}[Installing dependencies]${endColour}\n"
cd ~
sudo chsh -s /usr/bin/zsh root
sudo chsh -s /usr/bin/zsh $username
sudo pacman -S feh --noconfirm #
sudo pacman -S wget --noconfirm
sudo pacman -S xmonad xmonad-contrib --noconfirm
sudo pacman -S xmobar --noconfirm
sudo pacman -S compton --noconfirm
sudo pacman -S xclip --noconfirm
sudo pacman -S neofetch --noconfirm
sudo pacman -S zsh-syntax-highlighting --noconfirm
sudo pacman -S zsh-autosuggestions --noconfirm
sudo pacman -S nano-syntax-highlighting --noconfirm
sudo pacman -S fzf --noconfirm
sudo pacman -S dmenu --noconfirm
sudo pacman -S open-vm-tools --noconfirm
sudo pacman -S xclip --noconfirm
sudo pacman -S bat --noconfirm
sudo pacman -S lolcat --noconfirm
echo -e "\n${rojo}[Fixing errors in lolcat installation...]${endColour}\n"
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"
gem list
gem update
gem install lolcat
echo -e "\n${azul}[Successfully installed units]${endColour}\n"
#############################################################################################################
#                                                  FOLDERS CREATION                                         #
#############################################################################################################
echo -e "\n${amarillo}[Creating and copying files]${endColour}\n"
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
sudo cp neofetch/config.conf ~/.config/neofetch/config.conf
cp picom/picom.conf ~/.config/dotfiles/picom/picom.conf
chmod +x ~/.config/dotfiles/scripts/autostart.sh
chmod +x ~/.config/dotfiles/scripts/ethernet_status.sh
chmod +x ~/.config/dotfiles/scripts/hackthebox.sh
echo -e "\n${azul}[Files and archives, created and copied successfully]${endColour}\n"
#############################################################################################################
#                                                PLUGINS INSTALLATION                                       #
#############################################################################################################
echo -e "\n${amarillo}[Installing and configuring plugins]${endColour}\n"
cd ~/dotfiles
sudo cp fonts/Sauce-Code-Pro-Nerd-Font-Complete.ttf /usr/share/fonts/TTF/Sauce-Code-Pro-Nerd-Font-Complete.ttf
sudo chmod u+rw,g+r,o+r /usr/share/fonts/TTF/Sauce-Code-Pro-Nerd-Font-Complete.ttf
sudo cp zsh/sudo.plugin.zsh /usr/share/zsh/plugins/zsh-autosuggestions/sudo.plugin.zsh
sudo chmod u+rw,g+r,o+r /usr/share/zsh/plugins/zsh-autosuggestions/sudo.plugin.zsh
cd ~
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
cd ~/dotfiles
sudo cp zsh/zshrc ~/.zshrc
sudo cp zsh/p10k_user.zsh ~/.p10k.zsh
cd ~
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
cd /root/
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k
cd ~/dotfiles
sudo cp zsh/p10k_root.zsh  /root/.p10k.zsh
sudo rm /root/.zshrc
sudo ln -s -f /home/$username/.zshrc /root/.zshrc
echo -e "\n${azul}[Plugins successfully installed and configured]${endColour}\n"
#############################################################################################################
#                                           START AN ENABLE SERVICE                                         #
#############################################################################################################
echo -e "\n${amarillo}[Enabling services]${endColour}\n"
sudo systemctl start vmtoolsd.service
sudo systemctl enable vmtoolsd.service
sudo systemctl start sshd.service
sudo systemctl enable sshd.service
echo -e "\n${azul}[Successfully enabled services]${endColour}\n"
#############################################################################################################
#                                               XMONAD COMPILE                                              #
#############################################################################################################
echo -e "\n${amarillo}[Compiling xmonad]${endColour}\n"
xmonad --recompile &
echo -e "\n${azul}[xmonad successfully compiled]${endColour}\n"
echo -e "\n${amarillo}[Desktop successfully configured]${endColour}\n"
neofetch | lolcat
#############################################################################################################
#                                               END CONFIGURATION                                           #
#############################################################################################################