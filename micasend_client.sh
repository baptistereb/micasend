#!/usr/bin/bash

#configuration
host=""; 
user="";
token=""; #for verified account

#script pour passer en moderator mode
if [ "$1" = "-m" ]
then
	moderator_mode=1
else
	moderator_mode=0
fi

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
	echo -e $(curl -s $host/msg.php?getmsg=bash)
}

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
	elif [ "$command" = "/upuser" ]
	then
		UpUser $2 $3 $4
		read wait
	else
		arg=$@
		SendMsg ${arg// /§} ${user// /§}
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

#affichage
while [ 1 ]
do
	ReadMsg
	read newmsg
	ParsingCommand $newmsg
done

