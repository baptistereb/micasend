#!/usr/bin/bash

#configuration
host="127.0.0.1/micasend/webserver"; 
user="Rubiks";
token="1234"; #for verified account

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
	content=($(echo $(curl -s $host/msg.php?getmsg=content)))
	sender=($(echo $(curl -s $host/msg.php?getmsg=sender)))
	date_time=($(echo $(curl -s $host/msg.php?getmsg=date_time)))

	clear
	for ((i=0; i<$((${#content[*]})); i++ ))
	do
		content_i=${content[$i]//§/\ }
		sender_i=${sender[$i]//§/\ }
		date_time_i=${date_time[$i]//§/\ }
		echo -e "\033[31m"$sender_i"\033[0m "$date_time_i
		echo -e "\033[34m"$content_i"\033[0m"
	done
}

function ParsingCommand() {
	command=$1
	if [ "$command" = "/adduser" ]
	then
		newpseudo=$2
		newrank=$3
		AddUser $newpseudo $newrank
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

#affichage
while [ 1 ]
do
	ReadMsg
	read newmsg
	ParsingCommand $newmsg
done

