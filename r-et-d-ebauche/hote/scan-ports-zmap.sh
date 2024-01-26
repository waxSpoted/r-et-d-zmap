#!/bin/bash

liste_2ip_default="192.168.159.138 192.168.159.139"
liste_3ip_default="192.168.159.138 192.168.159.139 192.168.159.140"
liste_4ip_default="192.168.159.138 192.168.159.139 192.168.159.140 192.168.159.131"
single_ip_default="192.168.159.138"
ports_default="1-33767"

function scan_une_machine(){
	echo "voulez vous utiliser l'ip par défaut ? Y/n" 
	read default 
	if [ $default == "Y" ] || [ $default == "y" ]
	then 
		sudo echo ""
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
		sudo echo ""
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
		sudo echo ""
		ip1=$(echo $liste_2ip_default | tr ' ' '\n' | sed -n '1p')
		ip2=$(echo $liste_2ip_default | tr ' ' '\n' | sed -n '2p')
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
		sudo echo ""
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
		sudo echo ""
		ip1=$(echo $liste_3ip_default | tr ' ' '\n' | sed -n '1p')
		ip2=$(echo $liste_3ip_default | tr ' ' '\n' | sed -n '2p')
		ip3=$(echo $liste_3ip_default | tr ' ' '\n' | sed -n '3p')
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
		sudo echo ""
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
		sudo echo ""
		ip1=$(echo $liste_4ip_default | tr ' ' '\n' | sed -n '1p')
		ip2=$(echo $liste_4ip_default | tr ' ' '\n' | sed -n '2p')
		ip3=$(echo $liste_4ip_default | tr ' ' '\n' | sed -n '3p')
		ip4=$(echo $liste_4ip_default | tr ' ' '\n' | sed -n '4p')
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
		sudo echo ""
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

echo "1 : scanner une machine		[parallel]"
echo "2 : scanner deux machines	[parallel]"
echo "3 : scanner trois machines 	[parallel]"
echo "4 : scanner quatre machines 	[parallel]"
echo "5 : scan classique"
read choix 

if [ $choix == 1 ]
then
	scan_une_machine
fi 

if [ $choix == 2 ]
then 
	scan_deux_machines
fi

if [ $choix == 3 ]
then
	scan_trois_machines
fi

if [ $choix == 4 ]
then
	scan_quatre_machines
fi

if [ $choix == 5 ]
then
	scan_classique
fi
