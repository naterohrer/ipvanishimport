#!/bin/bash

user=$(whoami)
echo "
 __      _______ _______ 
 \ \    / /_   _|__   __|
  \ \  / /  | |    | |   
   \ \/ /   | |    | |   
    \  /   _| |_   | |   
     \/   |_____|  |_|   
  VPN Import Tool v.1.0
"
echo "What vpn client would you like to import?"
echo -e "1. IPVanish\n2. VPN 2\n3. VPN 3"
read vpn_type
case $vpn_type in
1)
if [ ! -d /home/$user/ipvanish-config ]; then
    mkdir /home/$user/ipvanish-config
    wget -O /home/$user/ipvanish-config/configs.zip https://configs.ipvanish.com/configs/configs.zip
    cd /home/$user/ipvanish-config
    unzip configs.zip
fi
;;
2)
echo "Add VPN #2"
;;
3)
echo "Add VPN #3"
;;
q)
echo "Quitting...."
    exit
;;
*)
echo "Unknown selection made. Dafuq u doin? I'm bailing...."
    exit
;;
esac


echo "How would you like to import?"
echo -e "1. By Country\n2. Country/City\n3. Random 15\n4. Dont import, Purge Connections."
read import_type
case $import_type in
1)
#================================================================
#=======================Country Import===========================
#================================================================
country_codes=($(ls /home/$user/ipvanish-config/ | egrep '\.ovpn$' | cut -d '-' -f 2 | uniq))
#echo "${country_codes[*]}"
clear
for i in "${country_codes[@]}"
do
    :
    #echo $i
    country=$(grep $i countries.txt | cut -d ',' -f 1)
    echo "$i : $country"
    #cat /home/$user/countries.txt | grep $i 
done
echo "Q : Quit Tool"
echo "Please enter the Country Code to import:"
read -n 2 ccode 
echo ""
country=$(grep $ccode countries.txt | cut -d ',' -f 1)
if nmcli connection show | grep ipvanish-${ccode^^}* 1> /dev/null 2>&1; then
	read -p $'\e[31mCaution!! IPVanish connection files already detected, would you like to overwrite? \e[0mY/N' -n 1 -r
	echo -e "\n"
	if [[ $REPLY =~ ^[Nn]$ ]]
	then
		echo "Exciting install script...."
    		exit
	fi
elif [[ $ccode =~ ^[Qq]$ ]]; then
    echo "Quitting Import Tool..."
    clear
    exit
fi
echo "IPVanish username:"
read username_input

read -p "IPVanish Login: $username_input. Is this correct? Y/N " -n 1 -r
if [[ $REPLY =~ ^[Nn]$ ]]
then
    echo "Please re-run the script with the correct username."
    exit
fi
echo -e "\n"
for i in $(ls /home/$user/ipvanish-config/ipvanish-${ccode}*.ovpn); do 
	nmcli connection import type openvpn file $i; 
	profile_name=$(basename $i .ovpn)
	nmcli connection modify $profile_name +vpn.data username=$username_input
    nmcli connection modify $profile_name ipv6.method disabled
    echo "Successfully imported $country vpn endpoints"
done
;;
2)
#================================================================
#==================Country/City Import===========================
#================================================================
country_codes=($(ls /home/$user/ipvanish-config/ | egrep '\.ovpn$' | cut -d '-' -f 2 | uniq))
#echo "${country_codes[*]}"
clear
for i in "${country_codes[@]}"
do
    :
    #echo $i
    country=$(grep $i countries.txt | cut -d ',' -f 1)
    echo "$i : $country"
    #cat /home/$user/countries.txt | grep $i 
done
echo "Q : Quit Tool"
echo "Please enter the Country Code to Navigate city options:"
read -n 2 ccode 
#echo -e "\n"
if [[ $ccode =~ ^[Qq]$ ]]; then
    echo "Quitting Import Tool..."
    clear
    exit
fi
echo -e "\n"
cities=($(ls "/home/$user/ipvanish-config/ipvanish-${ccode}"* | cut -d '-' -f 4 | uniq))
city_abbr=($(ls "/home/$user/ipvanish-config/ipvanish-${ccode}"* | rev | cut -d '-' -f 2 | uniq | rev))

country=$(grep $ccode countries.txt | cut -d ',' -f 1)
for ((i=0; i<=${#city_abbr[@]}; i++)); do
    printf '%s %s\n' "${city_abbr[i]} : ${cities[i]}"
done
echo "Please enter the City to import:"
read -n 3 citycode

echo "IPVanish username:"
read username_input

read -p "IPVanish Login: $username_input. Is this correct? Y/N" -n 1 -r
if [[ $REPLY =~ ^[Nn]$ ]]
then
    echo "Please re-run the script with the correct username."
    exit
fi
echo -e "\n"
for i in $(ls /home/$user/ipvanish-config/ipvanish-${ccode}*${citycode}*.ovpn); do 
	nmcli connection import type openvpn file $i; 
	profile_name=$(basename $i .ovpn)
	nmcli connection modify $profile_name +vpn.data username=$username_input
    nmcli connection modify $profile_name ipv6.method disabled    
    echo "Successfully imported $country vpn endpoints"
done
;;
3)
randy=($(ls ~/ipvanish-config/*.ovpn | sort -R | head -n 15))
echo ${randy[@]}
for o in "${randy[@]}"; do 
	nmcli connection import type openvpn file $o; 
	profile_name=$(basename $o .ovpn)
	nmcli connection modify $profile_name +vpn.data username=$username_input
    nmcli connection modify $profile_name ipv6.method disabled    
    #echo "Successfully imported $(basename $o .ovpn)."
done
;;
4)
#================================================================
#==================Nuke VPN Connections==========================
#================================================================
clear
echo "Commander Cody, the time has come. Execute Order 66."
echo "
⠀⠀⠀⠀⠀⠀⣀⠤⣒⣊⣭⠭⠉⠉⠑⠒⠢⠤⣀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢠⢊⡵⣪⡿⠋⠀⠀⠀⠀⠀⠀⠀⠁⠪⣝⢦⠀⠀⠀⠀⠀
⠀⠀⠀⢠⠃⣾⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡄⢣⠀⠀⠀⠀
⠀⠀⠀⣾⠰⣿⣿⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⢸⡄⠀⠀⠀
⠀⠀⢀⣿⢠⣿⣿⣸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡇⣼⣇⠀⠀⠀
⠀⠀⢿⣿⡿⣿⣿⣿⣷⣶⣶⣶⣶⣶⣆⣀⣀⣀⣹⣿⡿⣿⢿⠀⠀⠀
⠀⢀⣯⣿⣧⣿⣿⣿⣿⠿⣋⣥⠖⠢⢌⠙⢿⣶⣼⣿⢁⢸⣾⡧⠀⠀
⠀⠈⢿⢹⣶⣉⡉⠩⠰⣾⠏⠀⠀⠀⠀⠈⠂⠌⢉⣡⣾⢠⢽⣧⣄⠀
⠀⢀⠞⠹⣿⠃⠀⠀⣸⠇⠀⢀⣤⣤⣀⠀⠀⠀⠀⠘⣿⠀⠢⡙⢿⣧
⣰⣃⠤⣿⣌⢀⠀⠀⢸⣤⣾⠿⠿⠿⠿⣿⣦⡀⠀⢀⠏⢁⡴⠊⡂⣿
⣿⡇⠐⢝⠿⣿⡯⠲⢿⣿⣿⡏⠀⠀⠀⠀⠉⠛⠂⠌⠰⡿⠁⣠⣿⠇
⠹⣿⣤⣶⡏⠀⠈⠐⡀⢻⣿⠤⠤⠀⡀⠀⠀⡠⠀⠀⠀⢐⣴⡿⠋⠀
⠀⠹⣿⠻⣇⠠⢂⣐⡳⠤⢣⢰⣾⣦⢸⣖⠄⣐⣀⡒⢄⢠⣸⠁⠀⠀
⠀⠀⠈⢶⣄⠄⢯⣈⣻⡇⠸⣿⣿⣿⡷⠀⣻⣉⠿⠿⢘⣨⠇⠀⠀⠀
⠀⠀⠀⠀⠑⠠⢀⣀⣀⠤⠞⠉⠉⠙⠓⠤⣦⣀⣀⠤⠞⠁⠀⠀⠀⠀"
purge_count=$(nmcli connection show | grep -c ipvanish)
read -p "Are you sure you want to remove $purge_count enteries? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    purge=($(nmcli connection show | grep ipvanish))
    for y in "${purge[@]}"
    do
      :
      nmcli connection delete $y
    done
echo "VPN hosts nuked."  
fi
;;
*)
echo "Unknown selection made. Dafuq u doin? I'm bailing...."
    exit
;;
esac
