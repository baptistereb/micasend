#!/usr/bin/bash

#configuration
host="127.0.0.1/micasend"; 
user="votrenomd_utilisateur";

function SendMsg() {
	#on remplace les espaces par des §
	msg=${1// /§};
	sender=${2// /§};

	#on remplace les anti slash par des §
	msg=${msg//\\/§};
	sender=${sender//\\/§};

	curl -s $host/web/msg.php?message=$msg\&sender=$sender;
}

function ReadMsg() {
	content=($(echo $(curl -s $host/web/msg.php?getmsg=content)));
	sender=($(echo $(curl -s $host/web/msg.php?getmsg=sender)));
	date_time=($(echo $(curl -s $host/web/msg.php?getmsg=date_time)));

	clear
	for ((i=0; i<$((${#content[*]})); i++ ))
	do
		content_i=${content[$i]//§/\ }
		sender_i=${sender[$i]//§/\ }
		date_time_i=${date_time[$i]//§/\ }
		echo -e "\033[31m"$sender_i"\033[0m "$date_time_i;
		echo -e "\033[34m"$content_i"\033[0m";
	done
}

#affichage
while [ 1 ]
do
	ReadMsg;
	read newmsg;
	SendMsg ${newmsg// /§} ${user// /§};
done

