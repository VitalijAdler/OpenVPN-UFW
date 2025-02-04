#!/bin/bash

# Скрипт должен выполняться с правами root
if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт должен выполняться от root!"
   exit 1
fi

echo "Обновляем пакеты..."
apt update && apt upgrade -y

echo "Устанавливаем OpenVPN и UFW..."
apt install -y openvpn easy-rsa ufw

echo "Настраиваем UFW..."
bash firewall/ufw-rules.sh

echo "Копируем серверную конфигурацию..."
cp config/server.conf /etc/openvpn/server.conf

echo "Перезапускаем OpenVPN..."
systemctl enable openvpn
systemctl start openvpn
systemctl status openvpn

echo "OpenVPN и UFW успешно установлены!"
