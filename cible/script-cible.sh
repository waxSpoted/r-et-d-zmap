#!/bin/bash 

function modifport()
{
	list=()
	count=0
	for ((i=1; i<987; i++))
	do	
		valrand=$RANDOM
		a=$(expr $i + $valrand)
		if grep -sq $a <<< ${list[@]}
		then
			a=0
		else
			count=$((count+1))
			list+=("$a")
		fi
	done
	echo ""
	res="TCP_IN = \"20,21,22,25,53,853,80,110,143,443,465,587,993,995"
	for val in ${list[@]} 
	do
		res="$res,$val"
	done
	
	#res="TCP_IN = \"$(echo $res | cut -c12-)"
	res="$res\""
	echo $res > test.txt

	#remplacement des ports ouverts dans csf 
	cmd="sed -i -e 's/.*TCP_IN.*/${res}/g' test.txt"
	echo $cmd
	echo "un total de $count ports ont été écrit"
	
}

function reload(){
	sudo csf -r 
	sudo systemctl start csf
	sudo systemctl enable csf
	sudo systemctl status csf
}

function changeport(){
	echo "1 - charger le set de ports 1"
       	echo "2 - charger le set de ports 2"
	echo "3 - charger le set de ports 3"
	read choixport
	if [ $choixport == 1 ]
	then
		sudo cp ./file/csf1.conf /etc/csf/csf.conf
		reload
		echo ""
		echo "set numéro 1 chargé"
	fi
	
	if [ $choixport == 2 ]
	then
		sudo cp ./file/csf2.conf /etc/csf/csf.conf
		reload
		echo ""
		echo "set numéro 2 chargé"
	fi
	
	if [ $choixport == 3 ]
	then
		sudo cp ./file/csf3.conf /etc/csf/csf.conf
		reload
		echo ""
		echo "set numéro 3 chargé" 
	fi
}

if [ -d "/etc/csf" ];then 
	echo "csf est installé" 
	#echo "1 : commande pour les ports" 
	echo "1 : reload csf" 
	echo "2 : savoir les ports ouverts"
	echo "3 : charger de nouveaux ports"
	echo "99 : génération des ports, à éviter"
	read choix
	if [ $choix == 99 ]
	then
		modifport
	fi 
	if [ $choix == 1 ]
	then
		reload
	fi
	if [ $choix == 2 ]
	then
		sudo grep TCP_IN /etc/csf/csf.conf 
	fi
	if [ $choix == 3 ]
	then
		changeport
	fi	
else 
	echo "csf n'est pas installé" 
	sudo apt install wget libio-socket-ssl-perl git perl iptables libnet-libidn-perl libcrypt-ssleay-perl  libio-socket-inet6-perl libsocket6-perl sendmail dnsutils unzip
	wget http://download.configserver.com/csf.tgz
	tar -xvzf csf.tgz
	cd csf
	sudo bash install.sh
	sudo perl /usr/local/csf/bin/csftest.pl
	echo "csf est installé" 
	rm -f csf.tgz 
	rm -rf csf/
	sudo systemctl status csf 
fi 
