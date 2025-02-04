#!/bin/bash

echo "Настраиваем UFW..."

# Разрешаем OpenVPN и SSH
ufw allow 1194/udp
ufw allow 2222/tcp
ufw allow OpenSSH

# Включаем IP-форвардинг
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-openvpn.conf
sysctl --system

# Добавляем маскарадинг NAT в /etc/ufw/before.rules, если он ещё не добавлен
UFW_RULES="/etc/ufw/before.rules"

if ! grep -q "NAT table rules" $UFW_RULES; then
    echo "Добавляем NAT-маскарадинг в $UFW_RULES..."
    sed -i '1s/^/# OpenVPN NAT setup\n/' $UFW_RULES
    cat <<EOL >> $UFW_RULES

# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
COMMIT

# Форвардинг трафика между VPN и сетью
-A FORWARD -i tun0 -o eth0 -j ACCEPT
-A FORWARD -i eth0 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
EOL
else
    echo "Правила NAT уже добавлены в $UFW_RULES"
fi

# Перезапускаем UFW для применения правил
ufw reload
echo "UFW успешно настроен!"
