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
echo -e "\n${verde}[INICIANDO...]${endColour}\n"
#############################################################################################################
#                                             CONFIGURATION MANUAL                                          #
#############################################################################################################
sudo pacman -S xorg-server --noconfirm
sudo pacman -S alacritty --noconfirm
sudo pacman -S cmake freetype2 fontconfig pkg-config make libxcb --noconfirm
sudo echo 'include "/usr/share/nano-syntax-highlighting/*.nanorc"' >> /etc/nanorc
#############################################################################################################
#                                            INSTALLING DEPENDENCIES                                        #
#############################################################################################################
echo -e "\n${amarillo}[Installing dependencies]${endColour}\n"
cd /home/xllauca
pacman -S zsh --noconfirm
pacman -S git --noconfirm
sudo pacman -S python-pip --noconfirm
sudo pacman -S go --noconfirm
sudo pacman -S tmux --noconfirm

cd /home/xllauca
sudo chsh -s /usr/bin/zsh root
sudo chsh -s /usr/bin/zsh xllauca
sudo pacman -S feh --noconfirm #
sudo pacman -S exa --noconfirm
sudo pacman -S trayer --noconfirm
sudo pacman -S wget --noconfirm
sudo pacman -S vifm --noconfirm
sudo pacman -S nautilus --noconfirm
sudo pacman -S qutebrowser --noconfirm
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
sudo pacman -S lsd --noconfirm
sudo pacman -S flameshot --noconfirm
echo -e "\n${azul}[Successfully installed units]${endColour}\n"
#############################################################################################################
#                                                  FOLDERS CREATION                                         #
#############################################################################################################
echo -e "\n${amarillo}[Creating and copying files]${endColour}\n"
cd /home/xllauca/dotfiles
mkdir -p /home/xllauca/.config/dotfiles
mkdir -p /home/xllauca/.config/dotfiles/xmobar
mkdir -p /home/xllauca/.config/dotfiles/scripts
mkdir -p /home/xllauca/.config/dotfiles/backgrounds
mkdir -p /home/xllauca/.config/dotfiles/icons
mkdir -p /home/xllauca/.config/dotfiles/picom
cd /home/xllauca/dotfiles
mv xmonad/xmonad.hs /home/xllauca/.xmonad/xmonad.hs
mv xmobar/xmobarrc0  /home/xllauca/.config/dotfiles/xmobar/xmobarrc0
sudo mv scripts/exec-in-shell /usr/bin/
sudo chmod +x /usr/bin/exec-in-shell
mv scripts/autostart.sh /home/xllauca/.config/dotfiles/scripts/autostart.sh
mv scripts/ethernet_status.sh /home/xllauca/.config/dotfiles/scripts/ethernet_status.sh
mv scripts/hackthebox.sh /home/xllauca/.config/dotfiles/scripts/hackthebox.sh
mv backgrounds/sami.jpg /home/xllauca/.config/dotfiles/backgrounds/sami.jpg
mv backgrounds/aphack.jpg /home/xllauca/.config/dotfiles/backgrounds/aphack.jpg
mv backgrounds/circle.jpg /home/xllauca/.config/dotfiles/backgrounds/circle.jpg
mv icons/haskell_20.xpm /home/xllauca/.config/dotfiles/icons/haskell_20.xpm
sudo mv neofetch/config.conf /home/xllauca/.config/neofetch/config.conf
mv picom/picom.conf /home/xllauca/.config/dotfiles/picom/picom.conf
chmod +x /home/xllauca/.config/dotfiles/scripts/autostart.sh
chmod +x /home/xllauca/.config/dotfiles/scripts/ethernet_status.sh
chmod +x /home/xllauca/.config/dotfiles/scripts/hackthebox.sh
echo -e "\n${azul}[Files and archives, created and copied successfully]${endColour}\n"
#############################################################################################################
#                                                PLUGINS INSTALLATION                                       #
#############################################################################################################
echo -e "\n${amarillo}[Installing and configuring plugins]${endColour}\n"
sudo locale-gen
cd /home/xllauca/dotfiles
sudo mkdir /usr/share/fonts/TTF/
sudo mv fonts/* /usr/share/fonts/TTF/
sudo chmod -R u+rw,g+r,o+r /usr/share/fonts/TTF/*
sudo mv zsh/sudo.plugin.zsh /usr/share/zsh/plugins/zsh-autosuggestions/sudo.plugin.zsh
sudo chmod u+rw,g+r,o+r /usr/share/zsh/plugins/zsh-autosuggestions/sudo.plugin.zsh
cd /home/xllauca
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/xllauca/powerlevel10k
cd /home/xllauca/dotfiles
sudo mv zsh/zshrc /home/xllauca/.zshrc
sudo mv zsh/p10k_user.zsh /home/xllauca/.p10k.zsh
cd /home/xllauca
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
mv .tmux/.tmux.conf.local .
sudo cd /root/
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k
cd /home/xllauca/dotfiles
sudo mv zsh/p10k_root.zsh  /root/.p10k.zsh
sudo rm /root/.zshrc
sudo ln -s -f /home/xllauca/.zshrc /root/.zshrc
gem install colorls
sudo gem install colorls
cd /home/xllauca/dotfiles
git clone https://github.com/dracula/xfce4-terminal.git
cd xfce4-terminal
sudo mv Dracula.theme /usr/share/xfce4/terminal/colorschemes/
cd /home/xllauca/dotfiles
curl https://codeload.github.com/dracula/gtk/zip/master -o Dracula-theme.zip
unzip Dracula-theme.zip
mv gtk-master Dracula
sudo mv Dracula /usr/share/themes/
cd /home/xllauca/dotfiles
wget https://github.com/dracula/gtk/files/5214870/Dracula.zip
unzip Dracula
sudo mv Dracula /usr/share/icons/ 
sudo mv themes/settings.ini /usr/share/gtk-3.0/settings.ini
sudo mv themes/gtkrc /usr/share/gtk-2.0/gtkrc
echo -e "\n${azul}[Plugins successfully installed and configured]${endColour}\n"
#############################################################################################################
#                                           START AN ENABLE SERVICE                                         #
#############################################################################################################
echo -e "\n${amarillo}[Enabling services]${endColour}\n"
sudo systemctl start vmtoolsd.service
sudo systemctl enable vmtoolsd.service
vmware-toolbox-cmd timesync enable
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