#!/bin/bash

ip_cible="192.168.159.131"

echo "1 : installation zmap" 
echo "2 : execution du scan"
echo "3 : comparaison des resultats" 
echo "4 : execution du scan sur plusieurs machines" 
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
 	cd .. 
	sudo cp ./file/blocklist.conf /etc/zmap/blocklist.conf
	sudo zmap --version
}

function installation-openmp(){
	echo "zmap openmp pas encore disponible"
	echo "installation des dépendances" 
	sudo apt-get install build-essential cmake libgmp3-dev gengetopt libpcap-dev flex byacc libjson-c-dev pkg-config libunistring-dev libjudy-dev
	echo "installation du logiciel" 
	git clone https://github.com/zmap/zmap.git
	mv zmap zmap-openmp
	cp ./file/send-openmp.c ./zmap-openmp/src/send.c
	cd ./zmap-openmp
	cmake . 
	make -j4 
	sudo make install 
	echo "installation de zmap openmp terminé"
	cd .. 
	sudo cp ./file/blocklist.conf /etc/zmap/blocklist.conf
 	sudo zmap --version
}

function installation-mpi(){
	echo "zmap mpi pas encore disponible"
	echo "installation des dépendances" 
	sudo apt-get install build-essential cmake libgmp3-dev gengetopt libpcap-dev flex byacc libjson-c-dev pkg-config libunistring-dev libjudy-dev
	echo "installation du logiciel" 
	git clone https://github.com/zmap/zmap.git
	mv zmap zmap-mpi
	cp ./file/send-mpi.c ./zmap-openmp/src/send.c
	cd ./zmap-mpi
	cmake . 
	make -j4 
	sudo make install 
	echo "installation de zmap mpi terminé"
 	cd .. 
	sudo cp ./file/blocklist.conf /etc/zmap/blocklist.conf
	sudo zmap --version
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
	time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p 1-33767 $ip_cible > ./file/output.csv
	#time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p 1-33767 $ip_cible 2>automat.txt > ./file/output.csv
}

function automat(){
	debut=$(head -n 1 ./automat.txt | cut -c1-20)
	fin=$(tail -n 1 ./automat.txt | cut -c1-20)
	echo "début du scan : $debut" 
	echo "fin du scan : $fin"
	#t_debut=$(date -d $debut +"$s")
	#t_fin=$(date -d $fin +"$s")
	#echo $t_debut
	#temps=$((t_fin-t_debut))
	#echo $temps
	#temps=$(($fin-$debut))
	#echo $temps

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
	nbport=500
	if [ $conf == 1 ]
	then 
		#automat
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
			echo "tous les ports ont été découvert 500/500"
		else 
			echo "$diff ports n'ont pas été découvert sur 500"
		fi

	fi	
	if [ $conf == 2 ]
	then 
		#automat
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
			echo "tous les ports ont été découvert 500/500"
		else 
			echo "$diff ports n'ont pas été découvert sur 500"
		fi

	fi	
	
	if [ $conf == 3 ]
	then 
		#automat
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
			echo "tous les ports ont été découvert 500/500"
		else 
			echo "$diff ports n'ont pas été découvert sur 500"
		fi

	fi	
fi

if [ $choix == 4 ]
then 
	echo "combien de machines voulez-vous scanner ?" 
	read nombre
	listeIP=()
	for (( i=1; i<=$nombre; i++ ))
	do
		echo "quelle est l'ip de la machine $i ?"
		read ip
		listeIP+=($ip)
	done
	nombreport=$((nombre*500))
	nombretrouve=$(wc -l ./file/output.csv | cut -f 1 -d ' ')
	time sudo zmap --output-module=csv --output-fields=sport --output-filter="" --no-header-row -p 1-33767 ${listeIP[@]} > ./file/output.csv
	if [ $nombretrouve == $nombreport ]
	then 
		echo "tous les ports ont été trouvé $nombreport/$nombreport"
	else
		echo "tous les ports n'ont pas été trouvé" 
	fi	
fi
