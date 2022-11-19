function ParsingCommand() {
	command=$1
	if [ "$command" = "/adduser" ]
	then
		newpseudo=$2
		newrank=$3
		AddUser $newpseudo $newrank
		read wait
	elif [ "$command" = "/delmsg" ]
	then
		DelMsg $2
	elif [ "$command" = "/showuser" ]
	then
		ShowUser
		read wait
	elif [ "$command" = "/addgame" ]
	then
		player1=$2
		player2=$3
		AddGame $2 $3
	elif [ "$command" = "/play" ]
	then
		player2=$2
		Play $2
	elif [ "$command" = "/showgame" ]
	then
		ShowGame $2 $3
		read wait
	elif [ "$command" = "/delgame" ]
	then
		DelGame $2
	elif [ "$command" = "/help" ]
	then
		AffHelp
		read wait
	elif [ "$command" = "/upuser" ]
	then
		UpUser $2 $3 $4
		read wait
	else
		arg=$@
		SendMsg ${arg// /§} ${user// /§}
	fi
}

function SendMsg() {
	#on remplace les espaces par des §
	msg=${1// /§}
	sender=${2// /§}

	#on remplace les anti slash par des §
	msg=${msg//\\/§}
	sender=${sender//\\/§}

	curl -s $host/msg.php?message=$msg\&sender=$sender\&token=$token
}

function ReadMsg() {
	if [ "$moderator_mode" = "1" ]
	then
		echo -e $(curl -s $host/msg.php?getmsg=bashmod)
	else
		echo -e $(curl -s $host/msg.php?getmsg=bash)		
	fi
}

function AddUser() {
	newpseudo=$1
	newrank=$2
	echo Pseudo\ :\ $newpseudo
	echo Token\ :\ $(curl -s $host/adduser.php?insert=$newpseudo\&rank=$newrank\&adminpseudo=$user\&admintoken=$token)
}

function ShowUser() {
	echo -e $(curl -s $host/showuser.php?adminpseudo=$user\&admintoken=$token)
}

function UpUser() {
	userup=$1
	column=$2
	value=$3
	echo -e "\\033[35mBefore\\033[0m\n"
	ShowUser
	curl -s $host/upuser.php?user=$userup\&column=$column\&value=$value\&adminpseudo=$user\&admintoken=$token
	echo -e "\n\n\\033[35mAfter\\033[0m"
	ShowUser
}

function AffHelp() {
	clear
	echo -e "\\033[35m/showgame\\033[0m id_player1 id_player2"
	echo -e "\\033[33mPermet d'afficher la partie entre player1 et player2\\033[0m\n"

	echo -e "\n\n\\033[31m\\033[01mModerator\\033[0m\n\n"
	echo -e "\\033[35m/play\\033[0m id_de_votre_adversaire"
	echo -e "\\033[33mPermet d'afficher votre partie en cours avec un adversaire et de jouer si c'est à votre tour\\033[0m\n"
	echo -e "\\033[35m/delmsg\\033[0m id_message"
	echo -e "\\033[33mPermet de supprimer un message\\033[0m\n"


	echo -e "\n\n\\033[31m\\033[01mAdmin Only\\033[0m\n\n"
	echo -e "\\033[35m/adduser\\033[0m pseudo rank(de 1 à 15)"
	echo -e "\\033[33mPermet d'ajouter un utilisateur dans la base et retourne son token\\033[0m\n"
	echo -e "\\033[35m/showuser\\033[0m"
	echo -e "\\033[33mPermet d'afficher tout les utilisateurs et leurs parametres\\033[0m\n"
	echo -e "\\033[35m/addgame\\033[0m id_player1 id_player2"
	echo -e "\\033[33mPermet d'ajouter une partie entre player1 et player2\\033[0m\n"
	echo -e "\\033[35m/delgame\\033[0m id_game"
	echo -e "\\033[33mPermet de supprimer une partie\\033[0m\n"
	echo -e "\\033[35m/upuser\\033[0m id_utilisateur colonne_à_modifier nouvelle_valeur"
	echo -e "\\033[33mPermet de mettre à jour un utilisateur\\033[0m\n\n"

	echo -e "\\033[05m\\033[31m\\033[01m/!\ les commandes ne retournent pas forcément d'erreur si certains critères ne sont pas respectés\\033[0m"
}

function DelMsg() {
	msg=$1
	curl -s $host/delmsg.php?del=$msg\&adminpseudo=$user\&admintoken=$token
}

function ShowGame() {
	clear
	echo -e $(curl -s $host/showgame.php?player1=$1\&player2=$2)
}

function Play() {
	player1=$(curl -s $host/idof.php?pseudo=$user)
	player2=$1
	ShowGame $player1 $player2
	read coup
	if [ "$coup" = "/altf4" ]
	then
		echo "exiting..."
	elif [ "$coup" = "" ]
	then
		Play $player2
	else
		curl -s $host/playgame.php?player1=$player1\&player2=$player2\&adminpseudo=$user\&admintoken=$token\&coup=$coup
		Play $player2
	fi
}

function AddGame() {
	player1=$1
	player2=$2
	echo $(curl -s $host/addgame.php?player1=$1\&player2=$2\&adminpseudo=$user\&admintoken=$token)
}

function DelGame() {
	game=$1
	curl -s $host/delgame.php?del=$game\&adminpseudo=$user\&admintoken=$token
}

#affichage
while [ 1 ]
do
	ReadMsg
	read newmsg
	ParsingCommand $newmsg
done

