#!/bin/bash

token=$(jolie load.ol testserver.ol)
#echo $token
message=$(jolie testclient.ol)
#echo $message
jolie unload.ol $token

if [ "$message" == "This is from server: Message!" ]; then 
    exit 0;
    #echo "Message was equal" 
else 
    exit 1;
    #echo "Message not equal"
fi

