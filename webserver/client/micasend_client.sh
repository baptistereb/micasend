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

#affichage
while [ 1 ]
do
	ReadMsg
	read newmsg
	ParsingCommand $newmsg
done

