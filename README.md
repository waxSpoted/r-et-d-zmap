# recherche-zmap
Travail de recherche sur le logiciel zmap, parallélisation avec openmp

chmod +x ./r-et-d-zmap/hote/script-hote.sh

chmod +x ./r-et-d-zmap/cible/script-cible.sh

modifier dans le script "script-hote.sh" l'ip de la machine que vous voulez cibler : ip_cible="192.168.159.131"

# machine cible 

Pour la machine cible, veillez à charger un des 3 sets de configuration de port avec la commande 3 "charger de nouveaux ports" avant de lancer les scan 

# machine hote 

si une erreur apparait lors de l'installation de zmap, verifiez si un répertoire "zmap-classic" à été crée dans le repertoire courant, s'il n'a pas été crée relancer l'installation via le script 
