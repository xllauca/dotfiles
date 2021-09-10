#############################################################################################################
#                                                  INSTALL TOOLS                                            #
#############################################################################################################
echo -e "\n${amarillo}[Installing Tools]${endColour}\n"
sudo pacman -S evince --noconfirm
sudo pacman -S openvpn --noconfirm
sudo pacman -S burpsuite --noconfirm
sudo pacman -S mlocate --noconfirm
sudo pacman -S sqlmap --noconfirm
sudo pacman -S dnsenum --noconfirm
sudo pacman -S htop --noconfirm
go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
go get -v github.com/projectdiscovery/httpx/cmd/httpx
go get -v github.com/OWASP/Amass/v3/...
sudo pacman -S zaproxy  --noconfirm
go get -u github.com/ffuf/ffuf
sudo pacman -S nmap --noconfirm
sudo pacman -S  joomscan --noconfirm
cd /opt/
sudo mkdir tools
cd /opt/tools
sudo mkdir dirsearch
cd dirsearch
sudo git clone https://github.com/maurosoria/dirsearch.git
cd dirsearch
sudo pip3 install -r requirements.txt
sudo ln -s /opt/tools/dirsearch/dirsearch/dirsearch.py /usr/bin/dirsearch
cd /opt/tools
sudo mkdir ParamSpider
cd ParamSpider
sudo git clone https://github.com/devanshbatham/ParamSpider
cd ParamSpider
sudo pip3 install -r requirements.txt
sudo ln -s /opt/tools/ParamSpider/ParamSpider/paramspider.py /usr/bin/paramspider
sudo pacman -S netcat --noconfirm
sudo pip install wfuzz
sudo pacman -S gitrob  --noconfirm
sudo pacman -S wpscan  --noconfirm
sudo pacman -S rustscan  --noconfirm
go get -u github.com/tomnomnom/httprobe
go get github.com/003random/getJS
sudo pip3 install arjun
go get -v github.com/dwisiswant0/crlfuzz/cmd/crlfuzz
sudo pip install xsrfprobe
sudo pacman -S liffy --noconfirm
cd /opt/tools
sudo mkdir GraphQLmap
sudo git clone https://github.com/swisskyrepo/GraphQLmap
sudo ln -s /opt/tools/GraphQLmap/graphqlmap.py /usr/bin/graphqlmap
cd /opt/tools
sudo mkdir dom-red
cd dom-red
sudo git clone https://github.com/Naategh/dom-red.git
cd dom-red && sudo pip install -r requirements.txt
sudo chmod +x /opt/tools/dom-red/dom-red/dom-red.py
sudo ln -s /opt/tools/dom-red/dom-red/dom-red.py /usr/bin/domred
cd /opt/tools
sudo mkdir OpenRedireX
cd OpenRedireX
sudo git clone https://github.com/devanshbatham/OpenRedireX
sudo pip install aiohttp
sudo chmod +x /opt/tools/OpenRedireX/OpenRedireX/openredirex.py
sudo ln -s /opt/tools/OpenRedireX/OpenRedireX/openredirex.py /usr/bin/openredirex
cd /opt/tools
sudo mkdir smuggler
cd smuggler
sudo git clone https://github.com/defparam/smuggler.git
sudo ln -s /opt/tools/smuggler/smuggler/smuggler.py /usr/bin/smuggler
cd /opt/tools
sudo mkdir SSRFmap
cd SSRFmap
sudo git clone https://github.com/swisskyrepo/SSRFmap
cd SSRFmap/
sudo pip3 install -r requirements.txt
sudo chmod +x /opt/tools/SSRFmap/SSRFmap/ssrfmap.py
sudo ln -s /opt/tools/SSRFmap/SSRFmap/ssrfmap.py /usr/bin/ssrfmap
sudo pacman -S hashcat --noconfirm
cd /opt/tools
sudo mkdir brutemap
cd brutemap
sudo git clone https://github.com/brutemap-dev/brutemap.git
cd brutemap
sudo pip install -r requirements.txt
sudo chmod +x /opt/tools/brutemap/brutemap/brutemap.py
sudo ln -s /opt/tools/brutemap/brutemap/brutemap.py /usr/bin/brutemap
cd /opt/tools
sudo mkdir request_smuggler
cd request_smuggler
sudo git clone https://github.com/Sh1Yo/request_smuggler
cd request_smuggler
sudo pacman -S cargo --noconfirm
sudo cargo build --release
sudo ln -s /home/xllauca/.cargo/bin/request_smuggler /usr/bin/requestsmuggler
cd /opt/tools
sudo mkdir cerbrutus
cd cerbrutus
sudo git clone https://github.com/Cerbrutus-BruteForcer/cerbrutus
sudo pip install cryptography
sudo pip install six 
sudo pip install bcrypt
pip3 install PyNaCl
sudo chmod +x /opt/tools/cerbrutus/cerbrutus/cerbrutus.py

sudo pip3 install apkleaks
cd /opt/tools 
sudo mkdir jwt_tool 
cd jwt_tool
sudo git clone https://github.com/ticarpi/jwt_tool
cd jwt_tool
python3 -m pip install termcolor cprint pycryptodomex requests
sudo python3 -m pip install pycryptodomex
chmod +x /home/xllauca/jwt_tool/jwt_tool.py
sudo ln -s /home/xllauca/jwt_tool/jwt_tool.py /usr/bin/jwt_tool
cd /opt/tools 
sudo mkdir jexboss
cd jexboss 
sudo wget https://github.com/joaomatosf/jexboss/archive/master.zip
sudo unzip master.zip
cd jexboss-master
sudo pip install -r requires.txt
sudo chmod +x  jexboss.py #execute with sudo
sudo ln -s /opt/tools/jexboss/jexboss-master/jexboss.py /usr/bin/jexboss
go install github.com/OJ/gobuster/v3@latest
go get -u github.com/m4dm0e/dirdar
go get -u github.com/liamg/furious
go get github.com/tomnomnom/waybackurls
go get -u -v github.com/lukasikic/subzy
go install -v github.com/lukasikic/subzy
sudo ln -s /opt/tools/patator/patator/patator.py /usr/bin/patator
cd /opt/tools  
sudo mkdir patator
cd patator
sudo git clone https://github.com/lanjelot/patator.git
cd ~
wget https://raw.githubusercontent.com/iamj0ker/bypass-403/main/bypass-403.sh
chmod +x bypass-403.sh
sudo pacman -S figlet --noconfirm
sudo mv bypass-403.sh /usr/bin/bypass-403
cd /home/xllauca/go/bin
sudo chmod +x subzy
sudo chmod +x crlfuzz
sudo chmod +x httprobe
sudo chmod +x ffuf
sudo chmod +x nuclei
sudo chmod +x amass 
sudo chmod +x dirdar
sudo chmod +x subfinder
sudo chmod +x httpx
sudo chmod +x getJS
sudo chmod +x furious
sudo chmod +x gobuster
sudo chmod +x waybackurls
sudo mv * /usr/bin/
sudo pacman -S dirbuster  --noconfirm
sudo pacman -S shellerator  --noconfirm
sudo pacman -S enum4linux-ng  --noconfirm
cd /opt/tools
sudo mkdir Hash-Buster 
cd Hash-Buster 
sudo git clone https://github.com/s0md3v/Hash-Buster.git
cd Hash-Buster 
sudo make install
sudo chmod +x /opt/tools/Hash-Buster/Hash-Buster/hash.py
sudo ln -s /opt/tools/Hash-Buster/Hash-Buster/hash.py /usr/bin/hashbuster
cd /opt/tools
sudo mkdir CloudFail
cd CloudFail
sudo git clone https://github.com/m0rtem/CloudFail.git
cd CloudFail
sudo pip3 install -r requirements.txt
sudo chmod +x /opt/tools/CloudFail/CloudFail/cloudfail.py
sudo ln -s /opt/tools/CloudFail/CloudFail/cloudfail.py /usr/bin/cloudfail
cd /opt/tools
sudo mkdir LinkFinder
cd LinkFinder
sudo git clone https://github.com/GerbenJavado/LinkFinder.git
cd LinkFinder
sudo python setup.py install
sudo pip3 install -r requirements.txt
sudo ln -s /opt/tools/LinkFinder/LinkFinder/linkfinder.py /usr/bin/linkfinder
#_____________________________________________________
sudo pacman -S metasploit  --noconfirm #metasploit
#_____________________________________________________
python3 -m pip install pipx
pipx ensurepath
pipx install deathstar-empire #se llama Deathstar
pipx install crackmapexec
sudo ln -s /home/xllauca/.local/bin/crackmapexec /usr/bin/crackmapexec
#_____________________________________________________
cd /home/xllauca && mkdir projects && cd !$
python3 -m venv pwncat-env
source pwncat-env/bin/activate
git clone https://github.com/calebstewart/pwncat.git
cd /home/xllauca/projects/pwncat
python setup.py install
cd /opt/tools
sudo mkdir Sublist3r
cd Sublist3r
sudo git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r 
sudo pip install -r requirements.txt
sudo ln -s /opt/tools/Sublist3r/Sublist3r/sublist3r.py /usr/bin/sublist3r
sudo pacman -S exploitdb --noconfirm 
#sudo pacman -S wafw00f --noconfirm
#______________________________________________________
sudo pacman -S seclists  --noconfirm
echo -e "\n${azul}[Successfully installed tools]${endColour}\n"
#############################################################################################################
