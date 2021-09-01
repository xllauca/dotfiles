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
#systemctl start sshd
#systemctl enable sshd.socket
#systemctl start NetworkManager
#systemctl enable NetworkManager
#sed 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers > /etc/sudoers.new
#export EDITOR="cp /etc/sudoers.new"
#visudo
#rm /etc/sudoers.new
#useradd -m -g users -G wheel -s /bin/zsh xllauca
#passwd xllauca
#Edit on  /etc/pacman.conf 
#uncoment the next line
#Include = /etc/pacman.d/mirrorlist/
#pacman -Syu
#sudo pacman -S lightdm-webkit2-greeter --noconfirm
#sudo systemctl status lightdm
#/usr/lib/systemd/system/lightdm.service
#/etc/lightdm/lightdm.conf
#sudo systemctl enable lightdm.service
#sudo pacman -S xorg-server
#/etc/systemd/system/display-manager.service
#nano /etc/lightdm/lightdm-webkit2-greeter.conf
sudo echo 'include "/usr/share/nano-syntax-highlighting/*.nanorc"' >> /etc/nanorc
#############################################################################################################
#                                            INSTALLING DEPENDENCIES                                        #
#############################################################################################################
echo -e "\n${amarillo}[Installing dependencies]${endColour}\n"
su - xllauca
sudo pacman -S lightdm-webkit2-greeter lightdm-webkit-theme-litarvan --noconfirm
cd ~
pacman -S sudo --noconfirm
pacman -S zsh --noconfirm
pacman -S git --noconfirm

cd ~
sudo chsh -s /usr/bin/zsh root
sudo chsh -s /usr/bin/zsh xllauca
sudo pacman -S feh --noconfirm #
sudo pacman -S exa --noconfirm
sudo pacman -S trayer --noconfirm
sudo pacman -S wget --noconfirm
sudo pacman -S vifm --noconfirm
sudo pacman -S gnome-terminal --noconfirm
sudo pacman -S nautilus --noconfirm
sudo pacman -S nitrogen --noconfirm
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
#echo -e "\n${rojo}[Fixing errors in lolcat installation...]${endColour}\n"
#export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
#export PATH="$PATH:$GEM_HOME/bin"
#gem list
#gem update
#gem install lolcat
echo -e "\n${azul}[Successfully installed units]${endColour}\n"
#############################################################################################################
#                                                  INSTALL TOOLS                                            #
#############################################################################################################
echo -e "\n${amarillo}[Creating and copying files]${endColour}\n"
cd ~
git clone https://github.com/devanshbatham/ParamSpider
cd ParamSpider
sudo pip3 install -r requirements.txt
sudo pacman -S sublist3r --noconfirm
sudo pacman -S rustscan --noconfirm
sudo pacman -S joomscan --noconfirm
sudo pacman -S httprobe --noconfirm
sudo pacman -S crlfuzz --noconfirm
sudo pacman -S xsrfprobe --noconfirm
sudo pacman -S liffy --noconfirm
sudo pacman -S graphqlmap --noconfirm
cd ~
git clone https://github.com/Naategh/dom-red.git
cd dom-red && pip install -r requirements.txt
cd ~
git clone https://github.com/devanshbatham/OpenRedireX
sudo pacman -S smuggler --noconfirm
sudo pacman -S ssrfmap --noconfirm
cd /opt/
sudo git clone https://github.com/Cerbrutus-BruteForcer/cerbrutus
sudo pacman -S apkleaks --noconfirm
cd /opt/
sudo git clone https://github.com/ticarpi/jwt_tool
python3 -m pip install termcolor cprint pycryptodomex requests
chmod +x /home/xllauca/jwt_tool/jwt_tool.py
cd ~
git clone https://github.com/ticarpi/jwt_tool
cd jwt_tool
python3 -m pip install termcolor cprint pycryptodomex requests
python3 -m pip install colorama
sudo pacman -S jexboss --noconfirm
sudo pacman -S waybackurls --noconfirm
go get -u github.com/m4dm0e/dirdar
go get github.com/003random/getJS
go get -u github.com/liamg/furious
cd /home/xllauca/go/bin
sudo chmod +x dirdar
sudo chmod +x getJS
sudo chmod +x furious
sudo mv * /usr/bin/
sudo pacman -S figlet --noconfirm
wget https://raw.githubusercontent.com/iamj0ker/bypass-403/main/bypass-403.sh
chmod +x bypass-403.sh
sudo mv bypass-403.sh /usr/bin
sudo pacman -S deathstar --noconfirm
sudo pacman -S cloudfail --noconfirm
sudo pacman -S linkfinder --noconfirm
sudo pacman -S shellerator --noconfirm
sudo pacman -S enum4linux-ng --noconfirm
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
cd ~/dotfiles
mv xmonad/xmonad.hs ~/.xmonad/xmonad.hs
mv xmobar/xmobarrc0  ~/.config/dotfiles/xmobar/xmobarrc0
sudo mv scripts/exec-in-shell /usr/bin/
sudo chmod +x /usr/bin/exec-in-shell
mv scripts/autostart.sh ~/.config/dotfiles/scripts/autostart.sh
mv scripts/ethernet_status.sh ~/.config/dotfiles/scripts/ethernet_status.sh
mv scripts/hackthebox.sh ~/.config/dotfiles/scripts/hackthebox.sh
mv backgrounds/sami.jpg ~/.config/dotfiles/backgrounds/sami.jpg
mv backgrounds/aphack.jpg ~/.config/dotfiles/backgrounds/aphack.jpg
mv backgrounds/circle.jpg ~/.config/dotfiles/backgrounds/circle.jpg
mv icons/haskell_20.xpm ~/.config/dotfiles/icons/haskell_20.xpm
sudo mv neofetch/config.conf ~/.config/neofetch/config.conf
mv picom/picom.conf ~/.config/dotfiles/picom/picom.conf
chmod +x ~/.config/dotfiles/scripts/autostart.sh
chmod +x ~/.config/dotfiles/scripts/ethernet_status.sh
chmod +x ~/.config/dotfiles/scripts/hackthebox.sh
echo -e "\n${azul}[Files and archives, created and copied successfully]${endColour}\n"
#############################################################################################################
#                                                PLUGINS INSTALLATION                                       #
#############################################################################################################
echo -e "\n${amarillo}[Installing and configuring plugins]${endColour}\n"
cd ~/dotfiles
sudo mv fonts/* /usr/share/fonts/TTF/
sudo chmod -R u+rw,g+r,o+r /usr/share/fonts/TTF/*
sudo mv zsh/sudo.plugin.zsh /usr/share/zsh/plugins/zsh-autosuggestions/sudo.plugin.zsh
sudo chmod u+rw,g+r,o+r /usr/share/zsh/plugins/zsh-autosuggestions/sudo.plugin.zsh
cd ~
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
cd ~/dotfiles
sudo mv zsh/zshrc ~/.zshrc
sudo mv zsh/p10k_user.zsh ~/.p10k.zsh
cd ~
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
mv .tmux/.tmux.conf.local .
cd /root/
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k
cd ~/dotfiles
sudo mv zsh/p10k_root.zsh  /root/.p10k.zsh
sudo rm /root/.zshrc
sudo ln -s -f /home/xllauca/.zshrc /root/.zshrc
gem install colorls
sudo gem install colorls

cd ~/dotfiles
git clone https://github.com/dracula/xfce4-terminal.git
cd xfce4-terminal
sudo mv Dracula.theme /usr/share/xfce4/terminal/colorschemes/
cd ~/dotfiles
curl https://codeload.github.com/dracula/gtk/zip/master -o Dracula-theme.zip
unzip Dracula-theme.zip
mv gtk-master Dracula
sudo mv Dracula /usr/share/themes/
cd ~/dotfiles
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