#!/bin/bash 


function calcul1(){
	val=0
	fichier=$(cat port1.csv)
	for i in $fichier 
	do
		val=$((val+i))
	done
	res=$((val/500))
	echo "moyenne : $res"
	f=$(cat p1.csv)
	count=1
	for i in $f 
	do 
		if [ $count == 250 ]
		then
			echo "médiane $i"
			count=$((count+1))
		else
			count=$((count+1))
		fi
	done
}

function calcul2(){
	val=0
	fichier=$(cat port2.csv)
	for i in $fichier 
	do
		val=$((val+i))
	done
	res=$((val/500))
	echo "moyenne : $res"
	f=$(cat p2.csv)
	count=1
	for i in $f 
	do 
		if [ $count == 250 ]
		then
			echo "médiane $i"
			count=$((count+1))
		else
			count=$((count+1))
		fi
	done
}

function calcul3(){
	val=0
	fichier=$(cat port3.csv)
	for i in $fichier 
	do
		val=$((val+i))
	done
	res=$((val/500))
	echo "moyenne : $res"
	f=$(cat p3.csv)
	count=1
	for i in $f 
	do 
		if [ $count == 250 ]
		then
			echo "médiane $i"
			count=$((count+1))
		else
			count=$((count+1))
		fi
	done
}

echo "1 : port 1"
echo "2 : port 2"
echo "3 : port 3"
read choix 
if [ $choix == 1 ]
then
	calcul1
fi
if [ $choix == 2 ]
then 
	calcul2
fi
if [ $choix == 3 ]
then
	calcul3
fi
