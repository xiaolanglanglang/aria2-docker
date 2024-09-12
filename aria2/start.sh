#!/bin/sh

token="";
if [[ ! -f "/aria2/conf/aria2.conf" ]]
then
    echo conf not found, use default.
    cp /aria2/default/aria2.conf /aria2/conf/aria2.conf
    if [[ $ARIA2_TOKEN ]]
    then
        token=$ARIA2_TOKEN
    else
        token=`date +%s | sha256sum | base64 | head -c 32 ; echo`
        echo aria2 token is $token
    fi
    sed -i "s/rpc-secret=.*$/rpc-secret=$token/" /aria2/conf/aria2.conf
fi
if [[ ! -f /aria2/data/aria2.session ]]
then
    echo session not found, use default.
    cp /aria2/default/aria2.session /aria2/data/aria2.session
fi
if [[ ! -f /aria2/data/dht.dat ]]
then
    echo dht.dat not found, create one.
    touch /aria2/data/dht.dat
fi
if [[ ! -f /aria2/data/dht6.dat ]]
then
    echo dht6.dat not found, create one.
    touch /aria2/data/dht6.dat
fi

/usr/bin/aria2c --conf-path=/aria2/conf/aria2.conf