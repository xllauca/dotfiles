#############################################################################################################
#                                                  INSTALL TOOLS                                            #
#############################################################################################################
echo -e "\n${amarillo}[Installing Tools]${endColour}\n"
cd /home/xllauca
git clone https://github.com/devanshbatham/ParamSpider
cd ParamSpider
sudo pip3 install -r requirements.txt
sudo pacman -S netcat --noconfirm

#sudo pacman -S sublist3r --noconfirm
#sudo pacman -S rustscan --noconfirm
sudo pacman -S joomscan --noconfirm
sudo pacman -S httprobe --noconfirm
sudo pacman -S crlfuzz --noconfirm
sudo pacman -S xsrfprobe --noconfirm
sudo pacman -S liffy --noconfirm
sudo pacman -S graphqlmap --noconfirm
cd /home/xllauca
git clone https://github.com/Naategh/dom-red.git
cd dom-red && pip install -r requirements.txt
cd /home/xllauca
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
cd /home/xllauca
git clone https://github.com/ticarpi/jwt_tool
cd jwt_tool
python3 -m pip install termcolor cprint pycryptodomex requests
python3 -m pip install colorama
sudo pacman -S jexboss --noconfirm
sudo pacman -S waybackurls --noconfirm
go install github.com/OJ/gobuster/v3@latest
go get -u github.com/m4dm0e/dirdar
go get github.com/003random/getJS
go get -u github.com/liamg/furious
cd /home/xllauca/go/bin
sudo chmod +x dirdar
sudo chmod +x getJS
sudo chmod +x furious
sudo chmod +x gobuster
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
#_____________________________________
cd /opt/
sudo mkdir tools
cd tools
sudo mkdir pwncat
cd pwncat
sudo python3 -m venv pwncat-env
source pwncat-env/bin/activate
sudo git clone https://github.com/dannymas/pwncat-1.git
sudo pip install -U git+https://github.com/calebstewart/paramiko
sudo pip install git+https://github.com/JohnHammond/base64io-python
cd pwncat-1


echo -e "\n${azul}[Successfully installed tools]${endColour}\n"
#############################################################################################################
