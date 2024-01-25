#!/bin/bash

liste_ip_default="192.168.159.138 192.168.159.139"
single_ip_default="192.168.159.138"
ports_default="1-33767"

function scan_une_machine(){
	echo "voulez vous utiliser l'ip par défaut ? Y/n" 
	read default 
	if [ $default == "Y" ] || [ $default == "y" ]
	then 
		sudo echo ""
		echo $single_ip_default | parallel time sudo zmap --output-module=csv --output-fields=sport --output-filter=\"\" --no-header-row -p $ports_default {} > ports.csv
		echo "vous pouvez voir les ports ouverts dans ports.csv"
	else 
		echo "Quelle est l'ip de la machine que vous voulez scanner ?"
		read ip 
		echo "Quels sont les ports que vous voulez scanner ? 1-xxxxx"
		read ports
		sudo echo ""
		echo $ip | parallel time sudo zmap --output-module=csv --output-fields=sport --output-filter=\"\" --no-header-row -p $ports {} > ports.csv
		echo "vous pouvez voir les ports ouverts dans ports.csv"
	fi
}

function scan_plusieurs_machines(){
	if [ -f ./file/output.csv ]
	then
		echo "" > ./file/output.csv
	fi
	echo "voulez vous utiliser la liste d'ip par défaut ? Y/n" 
	read default 
	if [ $default == "Y" ] || [ $default == "y" ]
	then 
		sudo echo ""
		ip1=$(echo $liste_ip_default | cut -c-15)
		ip2=$(echo $liste_ip_default | cut -c16-31)
#		echo "ip 1 : $ip1"
#		echo "ip 2 : $ip2"
		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $ip1 > ./file/output1.csv &
		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $ip2 > ./file/output2.csv &
	else 
		echo "Combien de machines voulez-vous scanner ?"
		read nombre
		liste=""
		for (( i=1; i<= $nombre; i++ ))
		do
			echo "Quelle est l'ip de la machine $i ?"
			read ip
			liste="$liste $ip"
		done
		echo "Quels sont les ports que vous voulez scanner ? 1-xxxx"
		read ports
#		echo "liste : $liste"
		ip1=$(echo $liste | cut -c-15)
		ip2=$(echo $liste | cut -c16-31)
#		echo "ip 1 : $ip1"
#		echo "ip 2 : $ip2"
		echo "exécution du scan :"
		sudo echo ""
		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip1 >> ./file/output.csv &
		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip2 >> ./file/output.csv &
	
#		echo ${liste[@]} | parallel time sudo zmap --output-module=csv --output-fields=sport --output-filter=\"\" --no-header-row -p $ports {} > ports.csv
#		echo ${liste[1]} | parallel time sudo zmap --output-module=csv --output-fields=sport --output-filter=\"\" --no-header-row -p $ports {} > ports.csv
	
#		for i in ${liste[@]}
#		do 
#			#$(time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $i >> ./file/output.csv &)
#			echo "ip : $i"
#		done
	fi
}

function scan_classique(){
	echo ""
	echo "voulez vous utiliser la liste d'ip par défaut ? Y/n" 
	read default 
	if [ $default == "Y" ] || [ $default == "y" ]
	then 
		echo "Voulez-vous scanner 1 ou la liste de machine ?"
		echo "1 : 1 machine"
		echo "2 : liste de machine" 
		read choix 
		if [ $choix == 1 ]
		then 
			sudo echo ""
			time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $single_ip_default > ./file/output.csv 
		fi
		if [ $choix == 2 ]
		then 	
			sudo echo ""
			time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports_default $liste_ip_default > ./file/output.csv 
		fi 
	else 
		echo "Veuillez entrer l'ip ou les ip : "
		read ip 
		echo "Quels sont les ports que vous voulez scanner ? 1-xxxx"
		read ports 
		sudo echo ""
		time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p $ports $ip > ./file/output.csv 
	fi
}

echo "1 : scanner une machine		[parallel]"
echo "2 : scanner plusieurs machines	[parallel]"
echo "3 : scan classique"
read choix 

if [ $choix == 1 ]
then
	scan_une_machine
fi 

if [ $choix == 2 ]
then 
	scan_plusieurs_machines
fi

if [ $choix == 3 ]
then
	scan_classique
fi
