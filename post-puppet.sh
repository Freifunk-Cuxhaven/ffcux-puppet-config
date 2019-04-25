#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway

VPN_NUMBER=01
DOMAIN=cuxland.freifunk.net
TLD=ffcux
IP6PREFIX=fdec:c0f1:afda

# firewall config
build-firewall

#fastd ovh config
cd /etc/fastd/ffcux-mvpn/
git clone https://github.com/Freifunk-Cuxhaven/ffcux-gw-peers backbone
touch /usr/local/bin/update-fastd-gw
cat <<-EOF>> /usr/local/bin/update-fastd-gw
#!/bin/bash

cd /etc/fastd/ffcux-mvpn/backbone
git pull -q
EOF
chmod +x /usr/local/bin/update-fastd-gw

# check if everything is running:
check-services
echo 'maintenance off if needed !'
echo 'adapt hostname in the OVH-template /etc/cloud/templates/hosts.debian.tmpl and reboot'
echo 'add "include peers from "ffcux-gw-peers";" to fastd.conf'
