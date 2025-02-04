#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Использование: $0 client_name"
    exit 1
fi

CLIENT_NAME=$1
EASYRSA_DIR="/etc/openvpn/easy-rsa"

cd $EASYRSA_DIR
./easyrsa revoke $CLIENT_NAME
./easyrsa gen-crl
rm -f /etc/openvpn/clients/$CLIENT_NAME.*

echo "Клиент $CLIENT_NAME удалён!"
