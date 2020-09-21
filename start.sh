#!/bin/sh

token="";
if [[ $ARIA2_TOKEN ]]
then
    token=$ARIA2_TOKEN
else
    token=`date +%s | sha256sum | base64 | head -c 32 ; echo`
    echo aria2 token is $token
fi
sed -i "s/rpc-secret=.*$/rpc-secret=$token/" /aria2/conf/aria2.conf

/aria2/bin/aria2c --conf-path=/aria2/conf/aria2.conf