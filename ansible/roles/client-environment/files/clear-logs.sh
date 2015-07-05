#!/bin/bash
set -eux
# Keystone
function clear_keystone_log {
    server=$1
    uid=keystone
    gid=keystone
    dmode=0700
    ssh ${server} ps -ef | fgrep keystone || true
    set +e
    ssh ${server} sudo service apache2 stop
    set -e
    ssh ${server} ps -ef | fgrep keystone || true
    sleep 2
    ssh ${server} sudo rm -rf              /var/log/keystone
    ssh ${server} sudo mkdir               /var/log/keystone
    ssh ${server} sudo chown ${uid}:${gid} /var/log/keystone
    ssh ${server} sudo chmod ${dmode}      /var/log/keystone
    ssh ${server} sudo service apache2 start
}

clear_keystone_log sv1
clear_keystone_log sv2
clear_keystone_log sv3

# Glance
function clear_glance_log {
    server=$1
    uid=glance
    gid=adm
    dmode=0750
    ssh ${server} ps -ef | fgrep glance || true
    set +e
    ssh ${server} sudo initctl stop glance-registry
    ssh ${server} sudo initctl stop glance-api
    set -e
    ssh ${server} ps -ef | fgrep glance || true
    sleep 2
    ssh ${server} sudo rm -rf              /var/log/glance
    ssh ${server} sudo mkdir               /var/log/glance
    ssh ${server} sudo chown ${uid}:${gid} /var/log/glance
    ssh ${server} sudo chmod ${dmode}      /var/log/glance
    ssh ${server} sudo initctl start glance-registry
    ssh ${server} sudo initctl start glance-api
}

clear_glance_log sv1
clear_glance_log sv2
clear_glance_log sv3

# Nova
function clear_nova_log {
    server=$1
    uid=nova
    gid=adm
    dmode=0750
    ssh ${server} ps -ef | fgrep nova || true
    set +e
    ssh ${server} sudo initctl stop nova-api
    ssh ${server} sudo initctl stop nova-cert
    ssh ${server} sudo initctl stop nova-scheduler
    ssh ${server} sudo initctl stop nova-conductor
    ssh ${server} sudo initctl stop nova-novncproxy
    ssh ${server} sudo service nova-compute stop
    ssh ${server} sudo initctl stop nova-consoleauth
    set -e
    ssh ${server} ps -ef | fgrep nova || true
    sleep 2
    ssh ${server} sudo rm -rf              /var/log/nova
    ssh ${server} sudo mkdir               /var/log/nova
    ssh ${server} sudo chown ${uid}:${gid} /var/log/nova
    ssh ${server} sudo chmod ${dmode}      /var/log/nova
    ssh ${server} sudo initctl start nova-api
    ssh ${server} sudo initctl start nova-cert
    ssh ${server} sudo initctl start nova-scheduler
    ssh ${server} sudo initctl start nova-conductor
    ssh ${server} sudo initctl start nova-novncproxy
    ssh ${server} sudo service nova-compute start
    set +e
    ssh ${server} sudo initctl stop nova-consoleauth # Act/Stb service
    set -e
}

clear_nova_log sv1
clear_nova_log sv2
clear_nova_log sv3

# Neutron
function clear_neutron_log {
    server=$1
    uid=neutron
    gid=adm
    dmode=0750
    ssh ${server} ps -ef | fgrep neutron || true
    set +e
    ssh ${server} sudo initctl stop neutron-server
    ssh ${server} sudo initctl stop openvswitch-switch
    ssh ${server} sudo initctl stop neutron-plugin-openvswitch-agent
    ssh ${server} sudo initctl stop neutron-l3-agent
    ssh ${server} sudo initctl stop neutron-dhcp-agent
    ssh ${server} sudo initctl stop neutron-metadata-agent
    set -e
    ssh ${server} ps -ef | fgrep neutron || true
    sleep 2
    ssh ${server} sudo rm -rf              /var/log/neutron
    ssh ${server} sudo mkdir               /var/log/neutron
    ssh ${server} sudo chown ${uid}:${gid} /var/log/neutron
    ssh ${server} sudo chmod ${dmode}      /var/log/neutron
    ssh ${server} sudo initctl start neutron-server
    ssh ${server} sudo initctl start openvswitch-switch
    ssh ${server} sudo initctl start neutron-plugin-openvswitch-agent
    ssh ${server} sudo initctl start neutron-l3-agent
    ssh ${server} sudo initctl start neutron-dhcp-agent
    set +e
    ssh ${server} sudo initctl stop neutron-metadata-agent # Act/Stb service
    set -e
}

clear_neutron_log sv1
clear_neutron_log sv2
clear_neutron_log sv3

# Cinder
function clear_cinder_log {
    server=$1
    uid=cinder
    gid=adm
    dmode=0750
    ssh ${server} ps -ef | fgrep cinder || true
    set +e
    ssh ${server} sudo initctl stop cinder-scheduler
    ssh ${server} sudo initctl stop cinder-api
    ssh ${server} sudo initctl stop cinder-volume
    set -e
    ssh ${server} ps -ef | fgrep cinder || true
    sleep 2
    ssh ${server} sudo rm -rf              /var/log/cinder
    ssh ${server} sudo mkdir               /var/log/cinder
    ssh ${server} sudo chown ${uid}:${gid} /var/log/cinder
    ssh ${server} sudo chmod ${dmode}      /var/log/cinder
    ssh ${server} sudo initctl start cinder-scheduler
    ssh ${server} sudo initctl start cinder-api
    ssh ${server} sudo initctl start cinder-volume
}

clear_cinder_log sv1
clear_cinder_log sv2
clear_cinder_log sv3

