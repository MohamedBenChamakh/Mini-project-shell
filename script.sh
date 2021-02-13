#!/bin/zsh

function existe(){

	while getopts "u:g:" option
	do
			case $option in 
			
			u)   ligne=$(grep "^$2:" '/etc/passwd' | wc -l);
			;;

			 g)  ligne=$(grep "^$2:" '/etc/group' | wc -l);	
			;;
			esac

			if [ $ligne -eq 1 ];
			then 
				return 0;
			else
				return 1;
			fi
			
		
	done
	
}



function saisie(){
	while getopts "ug" option
	do
		case $option in
		u)	echo "Saisir le nom d'utilisateur :";
			
		;;
		g)	echo "Saisir le nom du groupe :";
		;;
		esac
		
			read NAME;
	
	done
	
	
}




function cree_user(){
	
	existe -u $1 ;
	case  $?  in
		0) echo "L'utilisateur existe déja !";
		;;
		1) echo "Vérification de l'existance de l'utilisateur terminée ...";
		 useradd $1;
		;;
	esac
		
	
	
}



function delete_user(){
	saisie -u;
	echo "Suppression du compte utilisateur : $NAME ...";
	existe -u $NAME ;
	case  $?  in
		1) echo "L'utilisateur n'existe pas !";
		;;
		0) echo "Suppression du compte utilisateur $1";
		  userdel -r $NAME;
		;;
	esac
	
}



function modif_user(){
	
	saisie -u;
	echo "Modification du compte utilisateur : $NAME ...";
	existe -u $NAME ;
	case  $?  in
		1) echo "L'utilisateur n'existe pas !";
		;;
		0) echo "Modification du compte utilisateur $1";
		   echo "1) -L : Vérouiller le compte ";
		   echo "2) -U : Dévérouiller le compte";
		   echo "3) -e : le mot de passe expire n jours apres le 1/1/1970";
		   echo "4) -u : modifie l'UID";
		   echo "5) -l : modifie le nom du login ";
		   echo "6) -p : ajouter un mot de passe ";
		   read modifier
		   
		   case $modifier in
			1) usermod -L $NAME
			;;
			2) usermod -U $NAME
			;;
			3) echo "Donnez le nombre de jours :";
			   read n; 
			   usermod -e $n $NAME;
			;;
			4) echo "Donnez le nouveau UID :";
			   read UID; 
			   usermod -u $UID $NAME;
			;;
			5) echo "Donnez le nouveau  login:";
			   read log; 
			   usermod -l $log $NAME;
			;;
			6) echo "Donnez un mot de passe";
			   read pass; 
			   usermod -p $pass $NAME;
			;;
		   esac

		;;
	esac
	
}



function affiche_user(){

	saisie -u;
	echo "Affichage du compte utilisateur : $NAME ...";
	existe -u $NAME ;
	case  $?  in
		1) echo "L'utilisateur n'existe pas !";
		;;
		0)echo "login:mot de passe:ID:GID:commentaire:répertoire de travail:shell"; 
		  echo  $(grep "^$NAME:" '/etc/passwd');
		  
		;;
	esac
	
}




function cree_liste_user(){
	
	echo "Saisir le nom du fichier : ";
	read nomf;
	for ligne in $(cat $nomf.txt); 
	do 

	cree_user $ligne; 
	done
	
	
}




function  affiche_group(){
	

	saisie -g;
	echo "Affichage du groupe : $NAME ...";
	existe -g $NAME ;
	case  $?  in
		1) echo "Le groupe n'existe pas !";
		;;
		0)echo "nom:numero:Liste des membres:"; 
		  echo  $(grep "^$NAME:" '/etc/group');
		  
		;;
	esac
	
	
}



function cree_group(){
	
	saisie g;
	echo "creation du groupe $NAME ...";
	existe g $NAME ;
	case  $?  in
		0) echo "Le groupe existe déja !";
		;;
		1) echo "Vérification de l'existance du groupe terminée ...";
		 groupadd $NAME;
		;;
	esac
	
}



function  delete_group(){
	
	saisie -g;
	echo "Suppression du groupe $NAME ...";
	existe -g $NAME ;
	case  $?  in
		1) echo "Le groupe $NAME n'existe pas !";
		;;
		0) echo "Vérification de l'existance du groupe terminée ...";
		 groupdel $NAME;
		;;
	esac
	
}




function modif_group(){
	
	saisie -g;
	echo "Modification du groupe $NAME ...";
	existe -g $NAME ;
	case  $?  in
		1) echo "Le groupe n'existe pas !";
		;;
		0) echo "Vérification de l'existance du groupe terminée ...";
		   echo "1) -n : renommer le groupe ";
		   echo "2) -g : modifier le GID ";
		   echo "3) -A : ajouter utilisateur spécifié";
		   echo "4) -R : supprimer l'utilisateur spécifié ";

		   read modifier
		   
		   case $modifier in
			1) echo "saisir le nouveau nom du groupe ";
			read new			;
			groupmod  -n $new $NAME
			;;
			2)echo "saisir le nouveau GID :";
			read gid
			groupmod -g $gid $NAME
			;;
			3) echo "Donnez le nom de l'utilisateur spécifié :";
			   read user; 
			   groupmod -A $user $NAME;
			;;
			4) echo "Donnez le nom de l'utilisateur à supprimer :";
			   read user; 
			   usermod -R $user $NAME;
			;;
		   esac
		;;
	esac
	
}



function  affiche_archive(){

	echo "Saisir le nom de l'archive à afficher ";
	read arc;
	echo "affichage de l'archive:  $arc";
	
	if [ -w $arc.tar.gz  ] ;      
	then
		tar -tzvf $arc.tar.gz;
	else
		echo "Vérifiez le type ou l'existance du fichier !";
	fi
	
}




function  archive_rep(){
	echo "Saisir le nom du repertoire ";
	read rep;
	
	if [ -d $rep  ] ;
	then
		echo "Archivage du repertoire :  $rep";
		echo "Saisir le nom de l'archive : ";
		read arc;
		tar -cvf $arc.tar $rep;
	else
		echo "Vérifiez le type ou l'existance du fichier !";
	fi
	
}



function  compress_archive(){
	
	echo "Saisir le nom de l'archive à compresser ";
	read arc;
	echo "compresser l'archive:  $arc";
	
	if [ -w $arc.tar  ] ;      
	then
		tar -czvf $arc.tar.gz $arc.tar;
	else
		echo "Vérifiez le type ou l'existance du fichier !";
	fi
	
}




function  decompress_archive(){
	
	echo "Saisir le nom de l'archive à decompresser ";
	read arc;
	echo "decompresser l'archive:  $arc";
	
	if [ -w $arc.tar.gz  ] ;      
	then
		tar -xzvf $arc.tar.gz ;
	else
		echo "Vérifiez le type ou l'existance du fichier !";
	fi
	
}




function  restaure_rep(){
	
	echo "Saisir le nom de l'archive à extraire ";
	read arc;
	
	if [ -w $arc.tar  ] ;
	then
		echo "Restauration du repertoire :  $rep";
		tar xvf $arc.tar ;
	else
		echo "Vérifiez le type ou l'existance du fichier !";
	fi
	
}

main(){
	echo "Bienvenue dans le MINI PROJET fait par MOHAMED BEN CHAMAKH";
	echo "1) existe";
	echo "2) saisie";
	echo "3) cree_user";
	echo "4) modif_user";
	echo "5) affiche_user";
	echo "6) delete_user";
	echo "7) cree_liste_user";
	echo "8) cree_group";
	echo "9) modif_group";
	echo "10) affiche_group";
	echo "11) delete_group";
	echo "12) archive_rep";
	echo "13) affiche_archive";
	echo "14) restaure_rep";
	echo "15) compress_archive";
	echo "16) decompress_archive";


	repeat=1;
	while [ $repeat -eq 1 ] 
	do
	echo "Selectionnez le numéro de la fonction à exécuter :";
	read value;
	
	case $value in
	1) echo "Vous avez selectionné : existe";
	   echo "Saisir le choix du fichier : (u) pour /etc/passwd ou bien (g) pour /etc/group";
	   read choice;

	   case "$choice" in
	   u)   saisie -u
		existe -u "$NAME"
	   ;;
	   g)   saisie -g
		existe -g "$NAME"
	   ;;
	   esac

	   if [ $? -eq 0 ] ;
	   then
		echo "$NAME existe !";
	   else
		echo "$NAME n'existe pas !";
	   fi
	;;
	2) echo "Vous avez selectionné : saisie";
	   echo "Saisir  : (u) pour entrer le nom d'utilisateur ou bien (g) pour entrer le nom du groupe";	
	   read choice;
	   case $choice in
	   u)   saisie -u; 
		
	   ;;
	   g)   saisie -g; 
		
	   ;;
	   esac
	;;
	3) echo "Vous avez selectionné : cree_user";
       	   saisie -u;
	   echo "creation du compte utilisateur pour $NAME ...";
	   cree_user $NAME;
	;;
	4) echo "Vous avez selectionné : modif_user";
	   modif_user;                                        
	;;
	5) echo "Vous avez selectionné : affiche_user";
	   affiche_user;
	;;
	6) echo "Vous avez selectionné : delete_user";
	   delete_user;
	;;
	7) echo "Vous avez selectionné : cree_liste_user";
	   cree_liste_user;
	;;
	8) echo "Vous avez selectionné : cree_group";
	  cree_group;
	;;
	9) echo "Vous avez selectionné : modif_group";
	  modif_group;
	;;
	10) echo "Vous avez selectionné : affiche_group";
	  affiche_group;
	;;
	11) echo "Vous avez selectionné : delete_group";
	  delete_group;
	;;
	12) echo "Vous avez selectionné : archive_rep";
	    archive_rep;
	;;
	13) echo "Vous avez selectionné : affiche_archive";
	    affiche_archive;
	;;
	14) echo "Vous avez selectionné : restaure_rep";
	   restaure_rep;
	;;
	15) echo "Vous avez selectionné : compress_archive";
	   compress_archive;	
	;;
	16) echo "Vous avez selectionné : decompress_archive";
	   decompress_archive;
	;;
	*) echo "Choix non valide";
	;;
	
	esac;
	echo "Voulez-vous selectionné une autre option ? 1=oui 0=non";
	read repeat;

	done

	echo "Vous avez quitté le programme .";
}


main;

