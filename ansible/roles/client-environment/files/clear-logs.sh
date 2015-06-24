#!/bin/bash
set -eux
# Keystone
ssh sv1 sudo service apache2 stop
ssh sv1 sudo rm -f /var/log/keystone/*
ssh sv1 sudo service apache2 start

ssh sv2 sudo service apache2 stop
ssh sv2 sudo rm -f /var/log/keystone/*
ssh sv2 sudo service apache2 start

ssh sv3 sudo service apache2 stop
ssh sv3 sudo rm -f /var/log/keystone/*
ssh sv3 sudo service apache2 start

# Glance
ssh sv1 sudo initctl stop glance-registry
ssh sv1 sudo initctl stop glance-api
ssh sv1 sudo rm -f /var/log/glance/*
ssh sv1 sudo initctl start glance-registry
ssh sv1 sudo initctl start glance-api

ssh sv2 sudo initctl stop glance-registry
ssh sv2 sudo initctl stop glance-api
ssh sv2 sudo rm -f /var/log/glance/*
ssh sv2 sudo initctl start glance-registry
ssh sv2 sudo initctl start glance-api

ssh sv3 sudo initctl stop glance-registry
ssh sv3 sudo initctl stop glance-api
ssh sv3 sudo rm -f /var/log/glance/*
ssh sv3 sudo initctl start glance-registry
ssh sv3 sudo initctl start glance-api

# Nova
ssh sv1 sudo initctl stop nova-api
ssh sv1 sudo initctl stop nova-cert
ssh sv1 sudo initctl stop nova-consoleauth
ssh sv1 sudo initctl stop nova-scheduler
ssh sv1 sudo initctl stop nova-conductor
ssh sv1 sudo initctl stop nova-novncproxy
ssh sv1 sudo service nova-compute stop
ssh sv1 sudo rm -f /var/log/nova/*
ssh sv1 sudo initctl start nova-api
ssh sv1 sudo initctl start nova-cert
ssh sv1 sudo initctl start nova-consoleauth
ssh sv1 sudo initctl start nova-scheduler
ssh sv1 sudo initctl start nova-conductor
ssh sv1 sudo initctl start nova-novncproxy
ssh sv1 sudo service nova-compute start

ssh sv2 sudo initctl stop nova-api
ssh sv2 sudo initctl stop nova-cert
ssh sv2 sudo initctl stop nova-consoleauth
ssh sv2 sudo initctl stop nova-scheduler
ssh sv2 sudo initctl stop nova-conductor
ssh sv2 sudo initctl stop nova-novncproxy
ssh sv2 sudo service nova-compute stop
ssh sv2 sudo rm -f /var/log/nova/*
ssh sv2 sudo initctl start nova-api
ssh sv2 sudo initctl start nova-cert
ssh sv2 sudo initctl start nova-consoleauth
ssh sv2 sudo initctl start nova-scheduler
ssh sv2 sudo initctl start nova-conductor
ssh sv2 sudo initctl start nova-novncproxy
ssh sv2 sudo service nova-compute start

ssh sv3 sudo initctl stop nova-api
ssh sv3 sudo initctl stop nova-cert
ssh sv3 sudo initctl stop nova-consoleauth
ssh sv3 sudo initctl stop nova-scheduler
ssh sv3 sudo initctl stop nova-conductor
ssh sv3 sudo initctl stop nova-novncproxy
ssh sv3 sudo service nova-compute stop
ssh sv3 sudo rm -f /var/log/nova/*
ssh sv3 sudo initctl start nova-api
ssh sv3 sudo initctl start nova-cert
ssh sv3 sudo initctl start nova-consoleauth
ssh sv3 sudo initctl start nova-scheduler
ssh sv3 sudo initctl start nova-conductor
ssh sv3 sudo initctl start nova-novncproxy
ssh sv3 sudo service nova-compute start

# Neutron
ssh sv1 sudo initctl stop neutron-server
ssh sv1 sudo initctl stop openvswitch-switch
ssh sv1 sudo initctl stop neutron-plugin-openvswitch-agent
ssh sv1 sudo initctl stop neutron-l3-agent
ssh sv1 sudo initctl stop neutron-dhcp-agent
ssh sv1 sudo initctl stop neutron-metadata-agent
ssh sv1 sudo rm -f /var/log/neutron/*
ssh sv1 sudo initctl start neutron-server
ssh sv1 sudo initctl start openvswitch-switch
ssh sv1 sudo initctl start neutron-plugin-openvswitch-agent
ssh sv1 sudo initctl start neutron-l3-agent
ssh sv1 sudo initctl start neutron-dhcp-agent
ssh sv1 sudo initctl start neutron-metadata-agent

ssh sv2 sudo initctl stop neutron-server
ssh sv2 sudo initctl stop openvswitch-switch
ssh sv2 sudo initctl stop neutron-plugin-openvswitch-agent
ssh sv2 sudo initctl stop neutron-l3-agent
ssh sv2 sudo initctl stop neutron-dhcp-agent
ssh sv2 sudo initctl stop neutron-metadata-agent
ssh sv2 sudo rm -f /var/log/neutron/*
ssh sv2 sudo initctl start neutron-server
ssh sv2 sudo initctl start openvswitch-switch
ssh sv2 sudo initctl start neutron-plugin-openvswitch-agent
ssh sv2 sudo initctl start neutron-l3-agent
ssh sv2 sudo initctl start neutron-dhcp-agent
ssh sv2 sudo initctl start neutron-metadata-agent

ssh sv3 sudo initctl stop neutron-server
ssh sv3 sudo initctl stop openvswitch-switch
ssh sv3 sudo initctl stop neutron-plugin-openvswitch-agent
ssh sv3 sudo initctl stop neutron-l3-agent
ssh sv3 sudo initctl stop neutron-dhcp-agent
ssh sv3 sudo initctl stop neutron-metadata-agent
ssh sv3 sudo rm -f /var/log/neutron/*
ssh sv3 sudo initctl start neutron-server
ssh sv3 sudo initctl start openvswitch-switch
ssh sv3 sudo initctl start neutron-plugin-openvswitch-agent
ssh sv3 sudo initctl start neutron-l3-agent
ssh sv3 sudo initctl start neutron-dhcp-agent
ssh sv3 sudo initctl start neutron-metadata-agent

# Cinder
