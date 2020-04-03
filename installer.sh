#!/bin/bash

if [[ "$(id -u)" -ne 0 ]]; then
   printf "\e[1;91m Run this program as root!\n\e[0m"
   exit 1
fi

echo  -e "\n\e[1;91m [-] installing sed, curl, jq, golan and python\e[0m"
apt-get -y install sed curl golang python python-pip jq
echo -e "\n\e[1;33m [-] installation is finished \e[0m"


mkdir /root/subdomain-enum
cd /root/subdomain-enum


echo  -e "\n\e[1;91m [-] installing sublist3r \e[0m"
sudo apt-get install sublist3r
echo -e "\n\e[1;33m [-] installation is finished \e[0m"


echo  -e "\n\e[1;91m [-] installing subfinder \e[0m"
wget https://github.com/projectdiscovery/subfinder/releases/download/v2.3.2/subfinder-linux-amd64.tar
tar -xzvf subfinder-linux-amd64.tar
mv subfinder-linux-amd64 /usr/bin/subfinder
echo -e "\n\e[1;33m [-] installation is finished \e[0m"


echo  -e "\n\e[1;91m [-] installing amass \e[0m"
apt-get -y install amass
echo -e "\n\e[1;33m [-] installation is finished \e[0m"


echo  -e "\n\e[1;91m [-] installing ct-exposer  \e[0m"
git clone https://github.com/chris408/ct-exposer
cd ct-exposer
pip install -r requirements.txt
echo -e "\n\e[1;33m [-] installation is finished \e[0m"
cd ../

echo  -e "\n\e[1;91m [-] installing subbrute \e[0m"
git clone https://github.com/TheRook/subbrute
cd subbrute
echo -e "\n\e[1;33m [-] installation is finished \e[0m"

