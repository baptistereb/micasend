#!/usr/bin/bash

#configuration
host="127.0.0.1/micasend/webserver"; 
user="Rubiks";
token="1234"; #for verified account

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
	id=($(echo $(curl -s $host/msg.php?getmsg=id)))
	content=($(echo $(curl -s $host/msg.php?getmsg=content)))
	sender=($(echo $(curl -s $host/msg.php?getmsg=sender)))
	date_time=($(echo $(curl -s $host/msg.php?getmsg=date_time)))
	id_sender=($(echo $(curl -s $host/msg.php?getmsg=id_certified_user)))

	clear
	for ((i=0; i<$((${#content[*]})); i++ ))
	do
		content_i=${content[$i]//§/\ }
		sender_i=${sender[$i]//§/\ }
		date_time_i=${date_time[$i]//§/\ }

    	bold=""
    	id_sender_i=""
		id_i=""

		if [ "$moderator_mode" -eq "1" ]
        then
        	id_i="\033[33m("${id[$i]}")"
        	if [ "${id_sender[$i]}" -ne "0" ]
	        then
	        	bold="\033[01m"
	        	id_sender_i="\033[33m("${id_sender[$i]}")"
	        fi
        fi

		
		echo -e "\033[31m"$bold$sender_i"\033[0m"$id_sender_i"\033[0m "$date_time_i" "$id_i
		echo -e "\033[34m"$content_i"\033[0m\n"
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
	elif [ "$command" = "/delmsg" ]
	then
		DelMsg $2
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

