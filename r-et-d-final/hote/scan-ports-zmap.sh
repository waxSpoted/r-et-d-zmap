#!/bin/bash

single_ip_default="192.168.159.138"
liste_2ip_default="192.168.159.138 192.168.159.139"
liste_3ip_default="192.168.159.138 192.168.159.139 192.168.159.131"
liste_4ip_default="192.168.159.138 192.168.159.139 192.168.159.140 192.168.159.131"
ports_default="1-33767"

function scan_une_machine(){
	echo "voulez vous utiliser l'ip par défaut ? Y/n" 
	read default 
	if [ $default == "Y" ] || [ $default == "y" ]
	then 
		sudo echo "scan de la machine $single_ip_default"
		echo $single_ip_default | parallel time sudo zmap --output-module=csv --output-fields=sport --output-filter=\"\" --no-header-row -p $ports_default {} > ./file/output.csv
		nb_port=$(wc -l ./file/output.csv | tr ' ' '\n' | sed -n '1p')
		if [ $nb_port == 500 ]
		then
			echo "tous les ports ont été découvert"
		else
			echo "tous les ports n'ont pas été découvert"
		fi
		echo "vous pouvez voir les ports ouverts dans ./file/output.csv"
	else 
		echo "Quelle est l'ip de la machine que vous voulez scanner ?"
		read ip 
		echo "Quels sont les ports que vous voulez scanner ? 1-xxxxx"
		read ports
		sudo echo "scan de la machine $ip"
		echo $ip | parallel time sudo zmap --output-module=csv --output-fields=sport --output-filter=\"\" --no-header-row -p $ports {} > ./file/output.csv
		nb_port=$(wc -l ./file/output.csv | tr ' ' '\n' | sed -n '1p')
		if [ $nb_port == 500 ]
		then
			echo "tous les ports ont été découvert"
		else
			echo "tous les ports n'ont pas été découvert"
		fi
		echo "vous pouvez voir les ports ouverts dans ./file/output.csv"
	fi
}

function scan_deux_machines(){
	if [ -f ./file/output.csv ]
	then
		echo "" > ./file/output.csv
	fi
	echo "voulez vous utiliser la liste d'ip par défaut ? Y/n" 
	read default 
	if [ $default == "Y" ] || [ $default == "y" ]
	then 
		ip1=$(echo $liste_2ip_default | tr ' ' '\n' | sed -n '1p')
		ip2=$(echo $liste_2ip_default | tr ' ' '\n' | sed -n '2p')
		sudo echo "scan des machines $ip1 et $ip2"
#		echo "ip 1 : $ip1"
#		echo "ip 2 : $ip2"
		#Execution dans différent processus avec & 
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $ip1 >> ./file/output.csv &
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $ip2 >> ./file/output.csv &
		
		#execution avec GNU parallel 
		parallel --tag -j2 time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default ::: $ip1 ::: $ip2 > ./file/output.csv
	else 
		liste=""
		for (( i=1; i<= 2; i++ ))
		do
			echo "Quelle est l'ip de la machine $i ?"
			read ip
			liste="$liste $ip"
		done
		echo "Quels sont les ports que vous voulez scanner ? 1-xxxx"
		read ports
		#echo "liste : $liste"
		ip1=$(echo $liste | tr ' ' '\n' | sed -n '1p')
		ip2=$(echo $liste | tr ' ' '\n' | sed -n '2p')
		#echo "ip 1 : $ip1"
		#echo "ip 2 : $ip2"
		echo "exécution du scan :"
		sudo echo "scan des machines $ip1 et $ip2"
		parallel --tag -j2 time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default ::: $ip1 ::: $ip2 > ./file/output.csv
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip1 >> ./file/output.csv &
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip2 >> ./file/output.csv &
#		echo ${liste[@]} | parallel time sudo zmap --output-module=csv --output-fields=sport --output-filter=\"\" --no-header-row -p $ports {} > ports.csv
#		echo ${liste[1]} | parallel time sudo zmap --output-module=csv --output-fields=sport --output-filter=\"\" --no-header-row -p $ports {} > ports.csv
	
#		for i in ${liste[@]}
#		do 
#			#$(time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $i >> ./file/output.csv &)
#			echo "ip : $i"
#		done
	fi
	echo "vous pouvez retrouver les ports ouverts dans ./file/output.csv"
}


function scan_trois_machines(){
	if [ -f ./file/output.csv ]
	then
		echo "" > ./file/output.csv
	fi
	echo "voulez vous utiliser la liste d'ip par défaut ? Y/n" 
	read default 
	if [ $default == "Y" ] || [ $default == "y" ]
	then 
		ip1=$(echo $liste_3ip_default | tr ' ' '\n' | sed -n '1p')
		ip2=$(echo $liste_3ip_default | tr ' ' '\n' | sed -n '2p')
		ip3=$(echo $liste_3ip_default | tr ' ' '\n' | sed -n '3p')
		sudo echo "scan des machines $ip1 , $ip2 et $ip3"
#		echo "ip 1 : $ip1"
#		echo "ip 2 : $ip2"
#		echo "ip 3 : $ip3"
		parallel --tag -j3 time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default ::: $ip1 ::: $ip2 ::: $ip3 > ./file/output.csv
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $ip1 >> ./file/output.csv &
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $ip2 >> ./file/output.csv &
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $ip3 >> ./file/output.csv &
	else 
		liste=""
		for (( i=1; i<= 3; i++ ))
		do
			echo "Quelle est l'ip de la machine $i ?"
			read ip
			liste="$liste $ip"
		done
		echo "Quels sont les ports que vous voulez scanner ? 1-xxxx"
		read ports
		#echo "liste : $liste"
		ip1=$(echo $liste | tr ' ' '\n' | sed -n '1p')
		ip2=$(echo $liste | tr ' ' '\n' | sed -n '2p')
		ip3=$(echo $liste | tr ' ' '\n' | sed -n '3p')
#		echo "ip 1 : $ip1"
#		echo "ip 2 : $ip2"
#		echo "ip 3 : $ip3"
		echo "exécution du scan :"
		sudo echo "scan des machines $ip1 , $ip2 et $ip3"
		parallel --tag -j3 time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports ::: $ip1 ::: $ip2 ::: $ip3 > ./file/output.csv
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip1 >> ./file/output.csv &
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip2 >> ./file/output.csv &
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip3 >> ./file/output.csv &
#		echo ${liste[@]} | parallel time sudo zmap --output-module=csv --output-fields=sport --output-filter=\"\" --no-header-row -p $ports {} > ports.csv
#		echo ${liste[1]} | parallel time sudo zmap --output-module=csv --output-fields=sport --output-filter=\"\" --no-header-row -p $ports {} > ports.csv
	
#		for i in ${liste[@]}
#		do 
#			#$(time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $i >> ./file/output.csv &)
#			echo "ip : $i"
#		done
	fi
	echo "vous pouvez retrouver les ports ouverts dans ./file/output.csv"
}

function scan_quatre_machines(){
	if [ -f ./file/output.csv ]
	then
		echo "" > ./file/output.csv
	fi
	echo "voulez vous utiliser la liste d'ip par défaut ? Y/n" 
	read default 
	if [ $default == "Y" ] || [ $default == "y" ]
	then 
		ip1=$(echo $liste_4ip_default | tr ' ' '\n' | sed -n '1p')
		ip2=$(echo $liste_4ip_default | tr ' ' '\n' | sed -n '2p')
		ip3=$(echo $liste_4ip_default | tr ' ' '\n' | sed -n '3p')
		ip4=$(echo $liste_4ip_default | tr ' ' '\n' | sed -n '4p')
		sudo echo "scan des machines $ip1 , $ip2 , $ip3 et $ip4"
#		echo "ip 1 : $ip1"
#		echo "ip 2 : $ip2"
#		echo "ip 3 : $ip3"
#		echo "ip 4 : $ip4"
		parallel --tag -j4 time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default ::: $ip1 ::: $ip2 ::: $ip3 ::: $ip4 > ./file/output.csv
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $ip1 >> ./file/output.csv &
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $ip2 >> ./file/output.csv &
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $ip3 >> ./file/output.csv &
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $ip4 >> ./file/output.csv &
	else 
		liste=""
		for (( i=1; i<= 4; i++ ))
		do
			echo "Quelle est l'ip de la machine $i ?"
			read ip
			liste="$liste $ip"
		done
		echo "Quels sont les ports que vous voulez scanner ? 1-xxxx"
		read ports
		#echo "liste : $liste"
		ip1=$(echo $liste | tr ' ' '\n' | sed -n '1p')
		ip2=$(echo $liste | tr ' ' '\n' | sed -n '2p')
		ip3=$(echo $liste | tr ' ' '\n' | sed -n '3p')
		ip4=$(echo $liste | tr ' ' '\n' | sed -n '4p')
		echo "exécution du scan :"
		sudo echo "scan des machines $ip1 , $ip2 , $ip3 et $ip4"
#		echo "ip 1 : $ip1"
#		echo "ip 2 : $ip2"
#		echo "ip 3 : $ip3"
#		echo "ip 4 : $ip4"
		parallel --tag -j4 time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports ::: $ip1 ::: $ip2 ::: $ip3 ::: $ip4 > ./file/output.csv
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip1 >> ./file/output.csv &
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip2 >> ./file/output.csv &
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip3 >> ./file/output.csv &
#		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip4 >> ./file/output.csv &
#		echo ${liste[@]} | parallel time sudo zmap --output-module=csv --output-fields=sport --output-filter=\"\" --no-header-row -p $ports {} > ports.csv
#		echo ${liste[1]} | parallel time sudo zmap --output-module=csv --output-fields=sport --output-filter=\"\" --no-header-row -p $ports {} > ports.csv
	
#		for i in ${liste[@]}
#		do 
#			#$(time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $i >> ./file/output.csv &)
#			echo "ip : $i"
#		done
	fi
	echo "vous pouvez retrouver les ports ouverts dans ./file/output.csv"
}

function scan_classique(){
	echo ""
	echo "voulez vous utiliser la liste d'ip par défaut ? Y/n" 
	read default 
	if [ $default == "Y" ] || [ $default == "y" ]
	then 
		echo "Voulez-vous scanner 1 ou la liste de machine ?"
		echo "1 : 1 machine"
		echo "2 : 2 machines"
	       	echo "3 : 3 machines" 	
		echo "4 : 4 machines"
		read choix 
		if [ $choix == 1 ]
		then 
			sudo echo ""
			time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $single_ip_default > ./file/output.csv 
			nb_port=$(wc -l ./file/output.csv | tr ' ' '\n' | sed -n '1p')
			if [ $nb_port == 500 ]
			then
				echo "tous les ports ont été découvert"
			else
				echo "tous les ports n'ont pas été découvert"
			fi
			echo "vous pouvez voir les ports ouverts dans ./file/output.csv"
		fi
		if [ $choix == 2 ]
		then 	
			sudo echo ""
			time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $liste_2ip_default > ./file/output.csv 
			nb_port=$(wc -l ./file/output.csv | tr ' ' '\n' | sed -n '1p')
			if [ $nb_port == 1000 ]
			then
				echo "tous les ports ont été découvert"
			else
				echo "tous les ports n'ont pas été découvert"
			fi
			echo "vous pouvez voir les ports ouverts dans ./file/output.csv"
		fi 
		if [ $choix == 3 ]
		then 	
			sudo echo ""
			time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $liste_3ip_default > ./file/output.csv 
			nb_port=$(wc -l ./file/output.csv | tr ' ' '\n' | sed -n '1p')
			if [ $nb_port == 1500 ]
			then
				echo "tous les ports ont été découvert"
			else
				echo "tous les ports n'ont pas été découvert"
			fi
			echo "vous pouvez voir les ports ouverts dans ./file/output.csv"
		fi 
		if [ $choix == 4 ]
		then 	
			sudo echo ""
			time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $liste_4ip_default > ./file/output.csv 
			nb_port=$(wc -l ./file/output.csv | tr ' ' '\n' | sed -n '1p')
			if [ $nb_port == 2000 ]
			then
				echo "tous les ports ont été découvert"
			else
				echo "tous les ports n'ont pas été découvert"
			fi
			echo "vous pouvez voir les ports ouverts dans ./file/output.csv"
		fi 
	else 
		echo "Veuillez entrer l'ip ou les ip : "
		read ip 
		echo "Quels sont les ports que vous voulez scanner ? 1-xxxx"
		read ports 
		sudo echo ""
		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip > ./file/output.csv 
		nb_port=$(wc -l ./file/output.csv | tr ' ' '\n' | sed -n '1p')
		echo "vous pouvez voir les $nb_port ports ouverts dans ./file/output.csv"
	fi
}

function installation-zmap(){
	if [ -d /etc/zmap ]
	then 
		echo "zmap est déjà installé"
	else 
		sudo apt update && sudo apt upgrade -y 
		echo "installation des dépendances"
		sudo apt-get install build-essential cmake libgmp3-dev gengetopt libpcap-dev flex byacc libjson-c-dev pkg-config libunistring-dev libjudy-dev git parallel
		echo "installation du logiciel"
		git clone https://github.com/zmap/zmap.git
		mv zmap zmap-classic
		cd ./zmap-classic
		cmake .
		make -j4
		sudo make install
		echo "installation de zmap classic terminé"
	 	cd ..
		sudo cp ./file/blocklist.conf /etc/zmap/blocklist.conf
		sudo zmap --version
		sudo rm -rf ./zmap-classic
	fi
}

function comparaison(){
	echo "combien de machines avez-vous scanner ?"
	read choix 
	
	if [ $choix == 1 ] 
	then
		res=0
		echo "Quel est la configuration de port de la machine 1 ? 1/2/3"
		read config1
		if [ $config1 == 1 ]
		then
			pwd1="./file/port1.csv"
		fi
		if [ $config1 == 2 ]
		then
			pwd1="./file/port2.csv"
		fi
		if [ $config1 == 3 ]
		then
			pwd1="./file/port3.csv"
		fi
		
		liste1=$(head -n 500 ./file/output.csv | awk '{print $NF}')
		
		for i in $liste1
		do
			if [ $(grep $i $pwd1) ] || [ $(grep $i $pwd2) ] 
			then
				res=$((res+1))
			fi
		done

		if [ $res == 500 ]
		then 
			echo "tous les ports ont été trouvé" 
		else 
			echo "tous les ports n'ont pas été trouvé" 
		fi
	fi
	
	if [ $choix == 2 ] 
	then
		res=0
		echo "Quel est la configuration de port de la machine 1 ? 1/2/3"
		read config1
		echo "Quel est la configuration de port de la machine 2 ? 1/2/3"
		read config2
		if [ $config1 == 1 ]
		then
			pwd1="./file/port1.csv"
		fi
		if [ $config1 == 2 ]
		then
			pwd1="./file/port2.csv"
		fi
		if [ $config1 == 3 ]
		then
			pwd1="./file/port3.csv"
		fi

		if [ $config2 == 1 ]
		then
			pwd2="./file/port1.csv"
		fi
		if [ $config2 == 2 ]
		then
			pwd2="./file/port2.csv"
		fi
		if [ $config2 == 3 ]
		then
			pwd2="./file/port3.csv"
		fi
		
		liste1=$(sed -n '1,500p' ./file/output.csv | awk '{print $NF}')
		liste2=$(sed -n '501,1000p' ./file/output.csv | awk '{print $NF}')
		
		for i in $liste1
		do
			if [ $(grep $i $pwd1) ] || [ $(grep $i $pwd2) ] 
			then
				res=$((res+1))
			fi
		done
		for i in $liste2
		do
			if [ $(grep $i $pwd1) ] || [ $(grep $i $pwd2) ] 
			then
				res=$((res+1))
			fi
		done

		if [ $res == 1000 ]
		then 
			echo "tous les ports ont été trouvé" 
		else 
			echo "tous les ports n'ont pas été trouvé" 
		fi
	fi
	
	if [ $choix == 3 ] 
	then
		res=0
		echo "Quel est la configuration de port de la machine 1 ? 1/2/3"
		read config1
		echo "Quel est la configuration de port de la machine 2 ? 1/2/3"
		read config2
		echo "Quel est la configuration de port de la machine 3 ? 1/2/3"
		read config3
		if [ $config1 == 1 ]
		then
			pwd1="./file/port1.csv"
		fi
		if [ $config1 == 2 ]
		then
			pwd1="./file/port2.csv"
		fi
		if [ $config1 == 3 ]
		then
			pwd1="./file/port3.csv"
		fi

		if [ $config2 == 1 ]
		then
			pwd2="./file/port1.csv"
		fi
		if [ $config2 == 2 ]
		then
			pwd2="./file/port2.csv"
		fi
		if [ $config2 == 3 ]
		then
			pwd2="./file/port3.csv"
		fi

		if [ $config3 == 1 ]
		then
			pwd3="./file/port1.csv"
		fi
		if [ $config3 == 2 ]
		then
			pwd3="./file/port2.csv"
		fi
		if [ $config3 == 3 ]
		then
			pwd3="./file/port3.csv"
		fi
		
		liste1=$(sed -n '1,500p' ./file/output.csv | awk '{print $NF}')
		liste2=$(sed -n '501,1000p' ./file/output.csv | awk '{print $NF}')
		liste3=$(sed -n '1001,1500p' ./file/output.csv | awk '{print $NF}')
		
		for i in $liste1
		do
			if [ $(grep $i $pwd1) ] || [ $(grep $i $pwd2) ] || [ $(grep $i $pwd3) ]
			then
				res=$((res+1))
			fi
		done
		for i in $liste2
		do
			if [ $(grep $i $pwd1) ] || [ $(grep $i $pwd2) ] || [ $(grep $i $pwd3) ]
			then
				res=$((res+1))
			fi
		done
		for i in $liste3
		do
			if [ $(grep $i $pwd1) ] || [ $(grep $i $pwd2) ] || [ $(grep $i $pwd3) ]
			then
				res=$((res+1))
			fi
		done
		if [ $res == 1500 ]
		then 
			echo "tous les ports ont été trouvé" 
		else 
			echo "tous les ports n'ont pas été trouvé" 
		fi
	fi

	if [ $choix == 4 ] 
	then
		echo ""
		res=0
		echo "Quel est la configuration de port de la machine 1 ? 1/2/3"
		read config1
		echo "Quel est la configuration de port de la machine 2 ? 1/2/3"
		read config2
		echo "Quel est la configuration de port de la machine 3 ? 1/2/3"
		read config3
		echo "Quel est la configuration de port de la machine 4 ? 1/2/3"
		read config4
		if [ $config1 == 1 ]
		then
			pwd1="./file/port1.csv"
		fi
		if [ $config1 == 2 ]
		then
			pwd1="./file/port2.csv"
		fi
		if [ $config1 == 3 ]
		then
			pwd1="./file/port3.csv"
		fi

		if [ $config2 == 1 ]
		then
			pwd2="./file/port1.csv"
		fi
		if [ $config2 == 2 ]
		then
			pwd2="./file/port2.csv"
		fi
		if [ $config2 == 3 ]
		then
			pwd2="./file/port3.csv"
		fi

		if [ $config3 == 1 ]
		then
			pwd3="./file/port1.csv"
		fi
		if [ $config3 == 2 ]
		then
			pwd3="./file/port2.csv"
		fi
		if [ $config3 == 3 ]
		then
			pwd3="./file/port3.csv"
		fi

		if [ $config4 == 1 ]
		then
			pwd4="./file/port1.csv"
		fi
		if [ $config4 == 2 ]
		then
			pwd4="./file/port2.csv"
		fi
		if [ $config4 == 3 ]
		then
			pwd4="./file/port3.csv"
		fi

		liste1=$(sed -n '1,500p' ./file/output.csv | awk '{print $NF}')
		liste2=$(sed -n '501,1000p' ./file/output.csv | awk '{print $NF}')
		liste3=$(sed -n '1001,1500p' ./file/output.csv | awk '{print $NF}')
		liste4=$(sed -n '1501,2000p' ./file/output.csv | awk '{print $NF}')
		
		for i in $liste1
		do
			if [ $(grep $i $pwd1) ] || [ $(grep $i $pwd2) ] || [ $(grep $i $pwd3) ] || [ $(grep $i $pwd4) ]
			then
				res=$((res+1))
			fi
		done
		for i in $liste2
		do
			if [ $(grep $i $pwd1) ] || [ $(grep $i $pwd2) ] || [ $(grep $i $pwd3) ] || [ $(grep $i $pwd4) ]
			then
				res=$((res+1))
			fi
		done
		for i in $liste3
		do
			if [ $(grep $i $pwd1) ] || [ $(grep $i $pwd2) ] || [ $(grep $i $pwd3) ] || [ $(grep $i $pwd4) ]
			then
				res=$((res+1))
			fi
		done
		for i in $liste4
		do
			if [ $(grep $i $pwd1) ] || [ $(grep $i $pwd2) ] || [ $(grep $i $pwd3) ] || [ $(grep $i $pwd4) ]
			then
				res=$((res+1))
			fi
		done
		if [ $res == 2000 ]
		then 
			echo "tous les ports ont été trouvé" 
		else 
			echo "tous les ports n'ont pas été trouvé" 
		fi
	fi

}

echo "1 : scanner une machine		[parallel]"
echo "2 : scanner deux machines	[parallel]"
echo "3 : scanner trois machines 	[parallel]"
echo "4 : scanner quatre machines 	[parallel]"
echo "5 : scan classique"
echo "6 : comparaison des résultats"
echo "99 : installer zmap "
read choix 

if [ $choix == 1 ]
then
	if [ -d /etc/zmap ]
	then 
		scan_une_machine
	else 
		echo "Veuillez installer zmap [99] avant d'exécuter un scan"
	fi
fi 

if [ $choix == 2 ]
then 
	if [ -d /etc/zmap ]
	then 
		scan_deux_machines
	else 
		echo "Veuillez installer zmap [99] avant d'exécuter un scan"
	fi
fi

if [ $choix == 3 ]
then
	if [ -d /etc/zmap ]
	then 
		scan_trois_machines
	else 
		echo "Veuillez installer zmap [99] avant d'exécuter un scan"
	fi
fi

if [ $choix == 4 ]
then
	if [ -d /etc/zmap ]
	then 
		scan_quatre_machines
	else 
		echo "Veuillez installer zmap [99] avant d'exécuter un scan"
	fi
fi

if [ $choix == 5 ]
then
	if [ -d /etc/zmap ]
	then 
		scan_classique
	else 
		echo "Veuillez installer zmap [99] avant d'exécuter un scan"
	fi
fi

if [ $choix == 6 ]
then
	comparaison
fi

if [ $choix == 99 ] 
then 
	installation-zmap
fi 
