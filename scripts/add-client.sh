#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Использование: $0 client_name"
    exit 1
fi

CLIENT_NAME=$1
EASYRSA_DIR="/etc/openvpn/easy-rsa"

cd $EASYRSA_DIR
./easyrsa build-client-full $CLIENT_NAME nopass
cp pki/private/$CLIENT_NAME.key pki/issued/$CLIENT_NAME.crt /etc/openvpn/clients/

echo "Клиент $CLIENT_NAME создан!"
