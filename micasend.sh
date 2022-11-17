#!/usr/bin/bash

host=""; 
user="";
token=""; #for verified account

export host
export user
export token

if [ "$1" = "-m" ]
then
    moderator_mode=1
else
    moderator_mode=0
fi
export moderator_mode

bash <(curl -L $host/client/micasend_client.sh)
