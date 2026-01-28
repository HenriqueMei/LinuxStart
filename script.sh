{\rtf1\ansi\ansicpg1252\cocoartf2867
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset0 AppleColorEmoji;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c1\c1;\cssrgb\c0\c0\c0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww17780\viewh21240\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs26 \cf2 #!/bin/bash\
\
sudo apt update && sudo apt full-upgrade -y \\\
\
\pard\pardeftab720\partightenfactor0
\cf2 \expnd0\expndtw0\kerning0
# Energia: Sempre Ligado (Tampa fechada e inatividade)\
sudo sed -i 's/.*HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf\
sudo sed -i 's/.*HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf\
sudo sed -i 's/.*HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf\
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target\
echo \'93Config inicial 
\f1 \uc0\u9989 
\f0 \'94\
\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf2 \kerning1\expnd0\expndtw0 #Acesso remoto\
\pard\pardeftab720\partightenfactor0
\cf2 \expnd0\expndtw0\kerning0
sudo apt install xrdp ssl-cert openssh-server -y \
sudo adduser xrdp ssl-cert\
sudo systemctl enable xrdp ssh\
echo \'93Acesso Remoto 
\f1 \uc0\u9989 
\f0 \'94\
\
#Python e Git\
# --- 1. Python Base e Git ---\
# Essencial para rodar o sistema e gerenciar reposit\'f3rios\
sudo apt install git python3 python3-pip python3-venv python3-full -y\
\
# --- 2. Bibliotecas de Desenvolvimento e Compila\'e7\'e3o ---\
# Necess\'e1rio para compilar o John (Jumbo) e as bibliotecas C do SpiderFoot (lxml)\
sudo apt install build-essential python3-dev libxml2-dev libxslt1-dev zlib1g-dev \\\
libssl-dev pkg-config libgmp-dev libbz2-dev libpcap-dev -y\
\
# --- 3. Depend\'eancias de Sistema para Ferramentas (SET e Recon) ---\
# Garante que o SEToolkit e outras ferramentas Python tenham acesso a m\'f3dulos do sistema\
sudo apt install python3-pexpect python3-cryptography python3-requests \\\
python3-openssl python3-pyte -y\
echo "Python e Pip e Git 
\f1 \uc0\u9989 
\f0 "\kerning1\expnd0\expndtw0 \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf2  \
#Ferramentas recon\
sudo apt install curl nmap wafw00f whatweb whois dnsutils hping3 nbtscan nikto -y\
\
\pard\pardeftab720\partightenfactor0
\cf2 \expnd0\expndtw0\kerning0
# Amass via Snap \
sudo apt install snapd -y \
sudo systemctl enable --now snapd.apparmor \
sleep 2 # Aguarda o servi\'e7o iniciar \
sudo snap install core && sudo snap install amass\kerning1\expnd0\expndtw0 \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf2 \
#WPSCAN\
sudo apt install ruby-full build-essential zlib1g-dev -y && sudo gem install wpscan\
\
#LBD\
mkdir -p ~/src && cd ~/src && git clone https://gitlab.com/kalilinux/packages/lbd\
\pard\pardeftab720\partightenfactor0
\cf2 \expnd0\expndtw0\kerning0
# Instalando o LBD\
cd ~/src/lbd \
# D\'e1 permiss\'e3o de execu\'e7\'e3o ao arquivo que est\'e1 na raiz \
chmod +x lbd \
# Copia para o diret\'f3rio de bin\'e1rios do sistema \
sudo cp lbd /usr/bin/lbd\kerning1\expnd0\expndtw0 \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf2 echo \'93Recon 
\f1 \uc0\u9989 
\f0 \'94\
\
#Jonh Jumbo\
cd ~/src\
sudo apt install git build-essential libssl-dev zlib1g-dev pkg-config libgmp-dev libbz2-dev -y\
git clone https://github.com/openwall/john -b bleeding-jumbo john\
cd john/src\
./configure && make -s clean && make -sj$(nproc)\
\
cd ~/src/john/run\
echo \'93Testando John 
\f1 \uc0\u55357 \u56580 
\f0 \'94\
./john --test=0\
./john --list=build-info\
\
#Se quiser interface grafica\
#cd ~/src\
#sudo apt install g++ qtbase5-dev qtchooser -y\
\pard\pardeftab720\partightenfactor0
\cf2 \expnd0\expndtw0\kerning0
if [ ! -d "john" ]; then\
	git clone https://github.com/openwall/john -b bleeding-jumbo john \
fi\kerning1\expnd0\expndtw0 \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf2 #cd johnny\
#export QT_SELECT=5\
#qmake && make -j$(nproc)\
#./johnny\
\
echo \'93John Jumbo 
\f1 \uc0\u9989 
\f0 \'94\
\
\pard\pardeftab720\partightenfactor0
\cf2 \expnd0\expndtw0\kerning0
# --- Criando apelido (alias) para o John --- \
# Verifica se o alias j\'e1 existe para n\'e3o duplicar no .bashrc \
if ! grep -q "alias john=" ~/.bashrc; then \
	echo "alias john='~/src/john/run/john'" >> ~/.bashrc \
fi \
echo "Apelido 'john' criado 
\f1 \uc0\u9989 
\f0 "\kerning1\expnd0\expndtw0 \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf2 \
#Tools Extras\
sudo apt install hydra gobuster sqlmap \expnd0\expndtw0\kerning0
proxychains4 tor mousepad \kerning1\expnd0\expndtw0 -y\
\
#OSINT\
\pard\pardeftab720\partightenfactor0
\cf0 \expnd0\expndtw0\kerning0
# --- Configura\'e7\'e3o OSINT --- \
cd ~/src \
# 1. Instalar o gerenciador 'uv' (necess\'e1rio para o theHarvester novo) \
curl -LsSf https://astral.sh/uv/install.sh | sh \
export PATH="$HOME/.local/bin:$PATH"\
\
# 2. Instalar theHarvester \
if [ ! -d "theHarvester" ]; then \
	git clone https://github.com/laramies/theHarvester.git \
fi \
cd theHarvester \
uv sync \
cd .. \
\
# 3. Instalar SpiderFoot \
if [ ! -d "spiderfoot-4.0" ]; then \
	wget https://github.com/smicallef/spiderfoot/archive/v4.0.tar.gz \
	tar zxvf v4.0.tar.gz \
	rm v4.0.tar.gz \
fi \
\
cd spiderfoot-4.0 \
python3 -m venv venv \
source venv/bin/activate \
pip install --upgrade pip \
#Ajuste de compatibilidade\
pip install "PyYAML>=6.0" "lxml>=5.2.0"\
sed -i '/pyyaml/d' requirements.txt\
sed -i '/lxml/d' requirements.txt\
\
pip install -r requirements.txt \
deactivate \
cd .. \
\
# --- Criando Aliases para facilitar o uso --- \
if ! grep -q "alias theharvester=" ~/.bashrc; then \
	echo "alias theharvester='cd ~/src/theHarvester && uv run theHarvester.py'" >> ~/.bashrc \
fi \
\
if ! grep -q "alias spiderfoot=" ~/.bashrc; then \
	echo "alias spiderfoot='cd ~/src/spiderfoot-4.0 && source venv/bin/activate && python3 sf.py'" >> ~/.bashrc \
fi\
\
#Setoolkit\
cd ~/src\
\pard\pardeftab720\partightenfactor0
\cf0 if [ ! -d "setoolkit" ]; then \
	git clone https://github.com/trustedsec/social-engineer-toolkit/ setoolkit \
fi\
\
cd setoolkit\
sudo python3 setup.py install\
\
# Alias para facilitar (precisa de sudo para rodar o SET) \
if ! grep -q "alias setoolkit=" ~/.bashrc; then \
	echo "alias setoolkit='sudo setoolkit'" >> ~/.bashrc \
fi \
echo \'93\'94OSINT 
\f1 \uc0\u9989 
\f0 \cf2 \
\
\
# --- Wordlists (SecLists e RockYou) --- \
echo "Baixando Wordlists (isso pode demorar)... 
\f1 \uc0\u55357 \u56580 
\f0 " \
sudo mkdir -p /usr/share/wordlists \
cd /usr/share/wordlists \
\
# SecLists (Depth 1 para ser mais r\'e1pido) \
if [ ! -d "SecLists" ]; then \
	sudo git clone --depth 1 https://github.com/danielmiessler/SecLists.git \
fi\
\
 # RockYou \
#sudo curl -L -o /usr/share/wordlists/rockyou.txt.gz https://github.com/branneman/PassiveTotal-Reference/raw/master/wordlists/rockyou.txt.gz \
#sudo gunzip -f /usr/share/wordlists/rockyou.txt.gz \
echo "Wordlists 
\f1 \uc0\u9989 
\f0 "\
\pard\pardeftab720\partightenfactor0
\cf2 \kerning1\expnd0\expndtw0 \
#Owasp ZAP\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf2 sudo snap install zaproxy \'97classic\
\
\pard\pardeftab720\partightenfactor0
\cf2 \expnd0\expndtw0\kerning0
echo "Configura\'e7\'e3o Finalizada! 
\f1 \uc0\u55357 \u56960 
\f0 "\
sleep 5\
sudo reboot}