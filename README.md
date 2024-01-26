# recherche-zmap
Travail de recherche sur le logiciel zma.

r-et-d-ebauche est l'ébauche de nos recherches sur la mise en place des différentes méthodes de parallélisation de zmap

r-et-d-final, propose un script permettant d'améliorer la performance de la tâche de découverte de port en parallélisant l'exécution des commandes zmap grâce à GNU parallel

chmod +x ./r-et-d-final/hote/scan-ports-zmap.sh

chmod +x ./r-et-d-final/cible/script-cible.sh

modifier dans le script "scan-ports-zmap.sh" l'ip ou les ip des machines que vous voulez scan : single_ip_default="192.168.159.131"

# machine cible 

Pour la machine cible, veillez à charger un des 3 sets de configuration de port avec la commande 3 "charger de nouveaux ports" avant de lancer les scan 

# machine hote 

si une erreur apparait lors de l'installation de zmap, verifiez si un répertoire "zmap-classic" à été crée dans le repertoire courant, s'il n'a pas été crée relancer l'installation via le script 
