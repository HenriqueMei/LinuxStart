#!/bin/bash

sudo apt update && sudo apt full-upgrade -y \

# Energia: Sempre Ligado (Tampa fechada e inatividade)
sudo sed -i 's/.*HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/.*HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/.*HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
echo “Config inicial ✅”

#Acesso remoto
sudo apt install xrdp ssl-cert openssh-server -y 
sudo adduser xrdp ssl-cert
sudo systemctl enable xrdp ssh
echo “Acesso Remoto ✅”

#Python e Git
# --- 1. Python Base e Git ---
# Essencial para rodar o sistema e gerenciar repositórios
sudo apt install git python3 python3-pip python3-venv python3-full -y

# --- 2. Bibliotecas de Desenvolvimento e Compilação ---
# Necessário para compilar o John (Jumbo) e as bibliotecas C do SpiderFoot (lxml)
sudo apt install build-essential python3-dev libxml2-dev libxslt1-dev zlib1g-dev \
libssl-dev pkg-config libgmp-dev libbz2-dev libpcap-dev -y

# --- 3. Dependências de Sistema para Ferramentas (SET e Recon) ---
# Garante que o SEToolkit e outras ferramentas Python tenham acesso a módulos do sistema
sudo apt install python3-pexpect python3-cryptography python3-requests \
python3-openssl python3-pyte -y
echo "Python e Pip e Git ✅"
 
#Ferramentas recon
sudo apt install curl nmap wafw00f whatweb whois dnsutils hping3 nbtscan nikto -y

# Amass via Snap 
sudo apt install snapd -y 
sudo systemctl enable --now snapd.apparmor 
sleep 2 # Aguarda o serviço iniciar 
sudo snap install core && sudo snap install amass

#WPSCAN
sudo apt install ruby-full build-essential zlib1g-dev -y && sudo gem install wpscan

#LBD
mkdir -p ~/src && cd ~/src && git clone https://gitlab.com/kalilinux/packages/lbd
# Instalando o LBD
cd ~/src/lbd 
# Dá permissão de execução ao arquivo que está na raiz 
chmod +x lbd 
# Copia para o diretório de binários do sistema 
sudo cp lbd /usr/bin/lbd
echo “Recon ✅”

#Jonh Jumbo
cd ~/src
sudo apt install git build-essential libssl-dev zlib1g-dev pkg-config libgmp-dev libbz2-dev -y
git clone https://github.com/openwall/john -b bleeding-jumbo john
cd john/src
./configure && make -s clean && make -sj$(nproc)

cd ~/src/john/run
echo “Testando John 🔄”
./john --test=0
./john --list=build-info

#Se quiser interface grafica
#cd ~/src
#sudo apt install g++ qtbase5-dev qtchooser -y
if [ ! -d "john" ]; then
	git clone https://github.com/openwall/john -b bleeding-jumbo john 
fi
#cd johnny
#export QT_SELECT=5
#qmake && make -j$(nproc)
#./johnny

echo “John Jumbo ✅”

# --- Criando apelido (alias) para o John --- 
# Verifica se o alias já existe para não duplicar no .bashrc 
if ! grep -q "alias john=" ~/.bashrc; then 
	echo "alias john='~/src/john/run/john'" >> ~/.bashrc 
fi 
echo "Apelido 'john' criado ✅"

#Tools Extras
sudo apt install hydra gobuster sqlmap proxychains4 tor mousepad -y

#OSINT
# --- Configuração OSINT --- 
cd ~/src 
# 1. Instalar o gerenciador 'uv' (necessário para o theHarvester novo) 
curl -LsSf https://astral.sh/uv/install.sh | sh 
export PATH="$HOME/.local/bin:$PATH"

# 2. Instalar theHarvester 
if [ ! -d "theHarvester" ]; then 
	git clone https://github.com/laramies/theHarvester.git 
fi 
cd theHarvester 
uv sync 
cd .. 

# 3. Instalar SpiderFoot 
if [ ! -d "spiderfoot-4.0" ]; then 
	wget https://github.com/smicallef/spiderfoot/archive/v4.0.tar.gz 
	tar zxvf v4.0.tar.gz 
	rm v4.0.tar.gz 
fi 

cd spiderfoot-4.0 
python3 -m venv venv 
source venv/bin/activate 
pip install --upgrade pip 
#Ajuste de compatibilidade
pip install "PyYAML>=6.0" "lxml>=5.2.0"
sed -i '/pyyaml/d' requirements.txt
sed -i '/lxml/d' requirements.txt

pip install -r requirements.txt 
deactivate 
cd .. 

# --- Criando Aliases para facilitar o uso --- 
if ! grep -q "alias theharvester=" ~/.bashrc; then 
	echo "alias theharvester='cd ~/src/theHarvester && uv run theHarvester.py'" >> ~/.bashrc 
fi 

if ! grep -q "alias spiderfoot=" ~/.bashrc; then 
	echo "alias spiderfoot='cd ~/src/spiderfoot-4.0 && source venv/bin/activate && python3 sf.py'" >> ~/.bashrc 
fi

#Setoolkit
cd ~/src
if [ ! -d "setoolkit" ]; then 
	git clone https://github.com/trustedsec/social-engineer-toolkit/ setoolkit 
fi

cd setoolkit
sudo python3 setup.py install

# Alias para facilitar (precisa de sudo para rodar o SET) 
if ! grep -q "alias setoolkit=" ~/.bashrc; then 
	echo "alias setoolkit='sudo setoolkit'" >> ~/.bashrc 
fi 
echo “”OSINT ✅


# --- Wordlists (SecLists e RockYou) --- 
echo "Baixando Wordlists (isso pode demorar)... 🔄" 
sudo mkdir -p /usr/share/wordlists 
cd /usr/share/wordlists 

# SecLists (Depth 1 para ser mais rápido) 
if [ ! -d "SecLists" ]; then 
	sudo git clone --depth 1 https://github.com/danielmiessler/SecLists.git 
fi

 # RockYou 
#sudo curl -L -o /usr/share/wordlists/rockyou.txt.gz https://github.com/branneman/PassiveTotal-Reference/raw/master/wordlists/rockyou.txt.gz 
#sudo gunzip -f /usr/share/wordlists/rockyou.txt.gz 
echo "Wordlists ✅"

#Owasp ZAP
sudo snap install zaproxy —classic

echo "Configuração Finalizada! 🚀"
sleep 5
sudo reboot
