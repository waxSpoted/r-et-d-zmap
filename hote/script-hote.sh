#!/bin/bash

ip_cible="192.168.159.131"

echo "1 : installation zmap" 
echo "2 : execution du scan"
echo "3 : comparaison des resultats" 
read choix 

function installation-classic(){
	echo "installation des dépendances" 
	sudo apt-get install build-essential cmake libgmp3-dev gengetopt libpcap-dev flex byacc libjson-c-dev pkg-config libunistring-dev libjudy-dev git
	echo "installation du logiciel" 
	git clone https://github.com/zmap/zmap.git
 	mv zmap zmap-classic
 	cd ./zmap-classic
	cmake . 
	make -j4 
	sudo make install 
	echo "installation de zmap classic terminé"
	sudo zmap --version
}

function installation-openmp(){
	echo "zmap openmp pas encore disponible"
	#echo "installation des dépendances" 
	#sudo apt-get install build-essential cmake libgmp3-dev gengetopt libpcap-dev flex byacc libjson-c-dev pkg-config libunistring-dev libjudy-dev
	#echo "installation du logiciel" 
	#cd ./zmap-openmp
	#cmake . 
	#make -j4 
	#sudo make install 
	#echo "installation de zmap openmp terminé"
	#sudo zmap --version
}

function installation-mpi(){
	echo "zmap mpi pas encore disponible"
	#echo "installation des dépendances" 
	#sudo apt-get install build-essential cmake libgmp3-dev gengetopt libpcap-dev flex byacc libjson-c-dev pkg-config libunistring-dev libjudy-dev
	#echo "installation du logiciel" 
	#cd ./zmap-mpi
	#cmake . 
	#make -j4 
	#sudo make install 
	#echo "installation de zmap mpi terminé"
	#sudo zmap --version
}

function installation(){
	echo "1 - installation classic"
	echo "2 - installation openmp"
	echo "3 - installation mpi"
	read install 

	if [ $install == 1 ]
	then
		installation-classic
	fi

	if [ $install == 2 ]
	then
		installation-openmp
	fi

	if [ $install == 3 ]
	then
		installation-mpi
	fi
}
function commande(){
	time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p 1-32767 $ip_cible > ./file/output.csv
}

if [ $choix == 1 ]
then
	installation
fi

if [ $choix == 2 ]
then 
	commande
fi

if [ $choix == 3 ]
then 
	res=$(cat ./file/output.csv)
	echo "Quel est la configuration des ports en place sur la machine cible ?"
	echo "Configuration de port 1 ?"
	echo "Configuration de port 2 ?"
       	echo "Configuration de port 3 ?"
	read conf 
	nbport=49
	if [ $conf == 1 ]
	then 
		count=0
		for i in $res
		do
			if [ $(grep $i ./file/port1.csv) ]
			then
				count=$((count+1))
			fi
		done
		diff=$((nbport-count))
		if [ $count == $nbport ]
		then
			echo "tous les ports ont été découvert 49/49"
		else 
			echo "$diff ports n'ont pas été découvert sur 49"
		fi

	fi	
	if [ $conf == 2 ]
	then 
		count=0
		for i in $res
		do
			if [ $(grep $i ./file/port2.csv) ]
			then
				count=$((count+1))
			fi
		done
		diff=$((nbport-count))
		if [ $count == $nbport ]
		then
			echo "tous les ports ont été découvert 49/49"
		else 
			echo "$diff ports n'ont pas été découvert sur 49"
		fi

	fi	
	
	if [ $conf == 3 ]
	then 
		count=0
		for i in $res
		do
			if [ $(grep $i ./file/port3.csv) ]
			then
				count=$((count+1))
			fi
		done
		diff=$((nbport-count))
		if [ $count == $nbport ]
		then
			echo "tous les ports ont été découvert 49/49"
		else 
			echo "$diff ports n'ont pas été découvert sur 49"
		fi

	fi	
fi

