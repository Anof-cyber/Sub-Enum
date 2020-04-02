#!/bin/bash

Ascii () {

		printf "\e[1;91m   _____       _           ______                    \e[0m\n"
		printf "\e[1;91m  / ____|     | |         |  ____|                    \e[0m\n"
		printf "\e[1;91m | (___  _   _| |__       | |__   _ __  _   _ _ __ ___ \e[0m\n"
		printf "\e[1;91m  \___ \| | | |  _ \      |  __| |  _ \| | | |  _   _ \ \e[0m\n"
		printf "\e[1;91m  ____) | |_| | |_) |     | |____| | | | |_| | | | | | | \e[0m\n"
		printf "\e[1;91m |_____/ \__,_|_.__/      |______|_| |_|\__,_|_| |_| |_| \e[0m\n"
		printf "\e[1;33m  Auto Subdomain Enumeration | Creator: @Ano_F_ (Twitter)\e[0m\n"
}

check_requirement () {
			command -v python > /dev/null 2>&1 || { echo >&2 "Python is not installed yet | Run ./installer.sh. exit."; exit 1; }
			command -v go > /dev/null 2>&1 || { echo >&2 "go is not installed yet. | Run ./installer.sh. exit."; exit 1; }
			command -v curl > /dev/null 2>&1 || { echo >&2 "curl is not installed yet. | Run ./installer.sh. exit."; exit 1; }
			command -v jq > /dev/null 2>&1 || { echo >&2 "jq is not installed yet. | Run ./installer.sh. exit."; exit 1; }
			command -v sed > /dev/null 2>&1 || { echo >&2 "sed is not installed yet. | Run ./installer.sh. exit."; exit 1; }
}



user_input () {
		read -p $'\n\e[1;92m enter the domain name: \e[0m' domain
		read -p $'\e[1;92m enter the name of output file(.txt): \e[0m'  file
		read -p $'\e[1;92m Do you want to use subbrute (y/n): \e[0m' subbrutes
}

subdomain () {
		#using sublist3r  
		echo  -e "\n\e[1;91m [-] using sublist3r to find subdomain... \e[0m"
		sublist3r -d $domain -o /root/subdomain-enum/sublist3r.txt  > /dev/null 2>&1
		echo -e "\n\e[1;33m [-] Scanning from Sublist3r is done\e[0m"

		#using subfinder
		echo  -e "\n\e[1;91m [-] using subfinder to find subdomain... \e[0m"
		subfinder -d $domain -silent -o /root/subdomain-enum/subfinder.txt > /dev/null 2>&1
		echo -e "\n\e[1;33m [-] Scanning from Subfinder is done\e[0m"

		# using amass
		echo  -e "\n\e[1;91m [-] using subfinder to find subdomain... \e[0m"
		amass enum -passive -d securitybrigade.com -o /root/subdomain-enum/amass.txt > /dev/null 2>&1
		echo -e "\n\e[1;33m [-] Scanning from Amss is done\e[0m"

		#using ct-exposer
		echo  -e "\n\e[1;91m [-] using ct-exposer to find subdomain... \e[0m"
		python /root/subdomain-enum/ct-exposer/ct-exposer.py -d $domain | grep $domain | awk '{print $2}' >  /root/subdomain-enum/ctexposer.txt
		echo -e "\n\e[1;33m [-] Scanning from Ct-Exposer is done\e[0m"

		#using crt.sh
		echo  -e "\n\e[1;91m [-] using crt.sh to find subdomain... \e[0m"
		curl -s "https://crt.sh/?q=%25.$domain&output=json" |jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | grep -o "\w.*$domain" | sort -u  > /root/subdomain-enum/crt.txt
		echo -e "\n\e[1;33m [-] Scanning from Crt.sh is done\e[0m"

		#using subbrute
		if [ $subbrutes = 'y' ];
		then 
   			echo  -e "\n\e[1;91m [-] using subbrute to find subdomain... \e[0m"
   			cd  /root/subdomain-enum/subbrute/
   			python subbrute.py $domain -o /root/subdomain-enum/subbrute.txt
   			echo -e "\n\e[1;33m [-] Scanning from subbrute is done\e[0m"
   			cat  /root/subdomain-enum/sublist3r.txt /root/subdomain-enum/subfinder.txt /root/subdomain-enum/crt.txt /root/subdomain-enum/amass.txt /root/subdomain-enum/ctexposer.txt /root/subdomain-enum/subbrute.txt | uniq > $file
   			rm  /root/subdomain-enum/sublist3r.txt /root/subdomain-enum/subfinder.txt /root/subdomain-enum/crt.txt  /root/subdomain-enum/amass.txt  /root/subdomain-enum/ctexposer.txt  /root/subdomain-enum/subbrute.txt 
		else
   			echo -e "\n\e[1;91m [-] Skipping subbrute as per your request\e[0m"
   			cat  /root/subdomain-enum/sublist3r.txt /root/subdomain-enum/subfinder.txt /root/subdomain-enum/crt.txt  /root/subdomain-enum/amass.txt  /root/subdomain-enum/ctexposer.txt | uniq > $file
 	 		rm  /root/subdomain-enum/sublist3r.txt /root/subdomain-enum/subfinder.txt /root/subdomain-enum/crt.txt  /root/subdomain-enum/amass.txt  /root/subdomain-enum/ctexposer.txt
		fi
}


Ascii
check_requirement
user_input
subdomain

#merge into single file
location=$(pwd)
echo -e "\n\e[1;91;1m [-] Output is saved in $location/$file \e[0m"
