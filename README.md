# trusty-openstack-ha
OpenStack High Availability cluster demo for Ubuntu trusty by Ansible and Vagrant.

## Abstract

This Vagrantfile will deploy the OpenStack Kilo environment on Ubuntu 14.04 LTS virtual machines with VirtualBox.
OpenStack environment are running on the server *sv1*, *sv2* and *sv3*, to form a high availability cluster. Server *starter* uses to build the environment.

![trusty-openstack-ha Networks](https://raw.githubusercontent.com/kiyoad/trusty-openstack-ha/master/images/trusty-openstack-ha-1.png)

![trusty-openstack-ha OpenStack environment components](https://raw.githubusercontent.com/kiyoad/trusty-openstack-ha/master/images/trusty-openstack-ha-2.png)

![trusty-openstack-ha OpenStack-V and OpenStack-C](https://raw.githubusercontent.com/kiyoad/trusty-openstack-ha/master/images/trusty-openstack-ha-3.png)

## Requirements

My development environment is shown below. I think that Ubuntu LinuxBox also works.

    $ cat /etc/redhat-release
    CentOS Linux release 7.1.1503 (Core)
    $ uname -a
    Linux zouk.local 3.10.0-229.11.1.el7.x86_64 #1 SMP Thu Aug 6 01:06:18 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
    $ cat /proc/meminfo | head -6
    MemTotal:       16243556 kB
    MemFree:          192120 kB
    MemAvailable:    2519276 kB
    Buffers:            3036 kB
    Cached:          2431356 kB
    SwapCached:         2380 kB
    $ vboxmanage --version
    4.3.30r101610
    $ vagrant --version
    Vagrant 1.7.2
    $ ansible --version
    ansible 1.9.2
    configured module search path = None
    $ vagrant box list
    trusty-server-cloudimg-amd64 (virtualbox, 0)

My Vagrant base box 'trusty-server-cloudimg-amd64' obtained from the following.
https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box

## How to use

1. Modify the following part in `ansible/group_vars/all` so that it fits your environment.(see previous picture.'trusty-openstack-ha Networks')

    ```
    neutron_ext_subnet_allocation_pool_start: 192.168.1.240
    neutron_ext_subnet_allocation_pool_end: 192.168.1.249
    neutron_ext_subnet_gateway: 192.168.1.1
    neutron_ext_subnet_cidr: 192.168.1.0/24
    neutron_demo_subnet_gateway: 192.168.99.1
    neutron_demo_subnet_cidr: 192.168.99.0/24
    ```

1. Enable `ansible.skip_tags = "openstack"` in Vagrantfile.

    ```
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/site.yml"
      # In execution of the first Playbook, after you build a cluster of
      # DB and AMQP, please comment out the following line
      # 'ansible.skip_tags' and do 'vagrant provision' again.
      ansible.skip_tags = "openstack"
    end
    ```

1. Run `vagrant up --no-provision`.

1. Run `vagrant provision`.

1. Run `vagrant reload`.

1. Disable `ansible.skip_tags = "openstack"` in Vagrantfile.

    ```
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/site.yml"
      # In execution of the first Playbook, after you build a cluster of
      # DB and AMQP, please comment out the following line
      # 'ansible.skip_tags' and do 'vagrant provision' again.
      #ansible.skip_tags = "openstack"
    end
    ```

1. Run `vagrant provision`.

1. Run `vagrant reload`.

1. Run `vagrant ssh starter` then login to the server `starter`.

1. The corosync cluster should look as follows.

    ```
    $ ssh sv1 sudo crm_mon -rfA1
    Last updated: Sun Sep  6 03:24:03 2015
    Last change: Sun Sep  6 03:13:37 2015 via cibadmin on sv3
    Stack: corosync
    Current DC: sv1 (167772427) - partition with quorum
    Version: 1.1.10-42f2063
    3 Nodes configured
    5 Resources configured


    Online: [ sv1 sv2 sv3 ]

    Full list of resources:

     Resource Group: g_services
         p_vip      (ocf::heartbeat:IPaddr2):       Started sv1
         p_haproxy  (ocf::heartbeat:haproxy):       Started sv1
     p_nova-consoleauth     (ocf::openstack:nova-consoleauth):      Started sv2
     Resource Group: g_metadata-service
         p_neutron-metadata-agent   (ocf::openstack:neutron-metadata-agent):        Started sv3
         p_neutron-l3-agent (ocf::openstack:neutron-agent-l3):      Started sv3

    Node Attributes:
    * Node sv1:
    * Node sv2:
    * Node sv3:

    Migration summary:
    * Node sv1:
    * Node sv2:
    * Node sv3:
    ```

1. Please check the status of HAProxy. ID:PASS=`clusteruser`:`Passw0rd`
  * If `p_haproxy` is running on `sv1`, use `http://localhost:15673/haproxy?hastats`.
  * If `p_haproxy` is running on `sv2`, use `http://localhost:25673/haproxy?hastats`.
  * If `p_haproxy` is running on `sv3`, use `http://localhost:35673/haproxy?hastats`.

  ![Statistics Report for HAProxy sample](https://raw.githubusercontent.com/kiyoad/trusty-openstack-ha/master/images/Statistics-Report-for-HAProxy-sample.png)

1. Run `cd ~/openstack/` on the server `starter`.

1. Run `./clear-logs.sh` for remove all the OpenStack logs and restart all the OpenStack services.

1. Run `source admin-openrc.sh`.

1. The `nova service-list` should look as follows.

    ```
    $ nova service-list
    +----+------------------+------+----------+---------+-------+----------------------------+-----------------+
    | Id | Binary           | Host | Zone     | Status  | State | Updated_at                 | Disabled Reason |
    +----+------------------+------+----------+---------+-------+----------------------------+-----------------+
    | 1  | nova-scheduler   | sv1  | internal | enabled | up    | 2015-09-06T04:12:17.000000 | -               |
    | 4  | nova-cert        | sv1  | internal | enabled | up    | 2015-09-06T04:12:16.000000 | -               |
    | 7  | nova-conductor   | sv1  | internal | enabled | up    | 2015-09-06T04:12:17.000000 | -               |
    | 10 | nova-scheduler   | sv2  | internal | enabled | up    | 2015-09-06T04:12:25.000000 | -               |
    | 13 | nova-cert        | sv2  | internal | enabled | up    | 2015-09-06T04:12:24.000000 | -               |
    | 16 | nova-conductor   | sv2  | internal | enabled | up    | 2015-09-06T04:12:25.000000 | -               |
    | 19 | nova-compute     | sv2  | nova     | enabled | up    | 2015-09-06T04:12:16.000000 | -               |
    | 22 | nova-scheduler   | sv3  | internal | enabled | up    | 2015-09-06T04:12:18.000000 | -               |
    | 25 | nova-cert        | sv3  | internal | enabled | up    | 2015-09-06T04:12:16.000000 | -               |
    | 28 | nova-conductor   | sv3  | internal | enabled | up    | 2015-09-06T04:12:18.000000 | -               |
    | 31 | nova-consoleauth | sv2  | internal | enabled | up    | 2015-09-06T04:12:22.000000 | -               |
    | 34 | nova-compute     | sv3  | nova     | enabled | up    | 2015-09-06T04:12:20.000000 | -               |
    | 35 | nova-consoleauth | sv3  | internal | enabled | down  | 2015-09-06T03:55:40.000000 | -               |
    +----+------------------+------+----------+---------+-------+----------------------------+-----------------+
    ```

    Sometimes `nova-compute` fail to come up. In that case, it may be to try the following.

    ```
    $ ssh sv2 sudo initctl stop nova-compute
    $ ssh sv3 sudo initctl stop nova-compute
    ```

    Wait for a while.

    ```
    $ ssh sv2 sudo initctl start nova-compute
    $ ssh sv3 sudo initctl start nova-compute
    ```

    Wait for a while and run `nova service-list` again.

1. The `neutron agent-list` should look as follows.

    ```
    $ neutron agent-list
    +--------------------------------------+--------------------+------+-------+----------------+---------------------------+
    | id                                   | agent_type         | host | alive | admin_state_up | binary                    |
    +--------------------------------------+--------------------+------+-------+----------------+---------------------------+
    | 0f355e9b-59f6-45a1-b5c8-0d5507f8b1cc | Open vSwitch agent | sv2  | :-)   | True           | neutron-openvswitch-agent |
    | 1f350966-5073-4a14-b13d-c4ae10f9968d | Open vSwitch agent | sv1  | :-)   | True           | neutron-openvswitch-agent |
    | 33695468-1f1f-4781-bfb8-e6e4b9799d8a | DHCP agent         | sv2  | :-)   | True           | neutron-dhcp-agent        |
    | 42bb5500-d9b6-48b4-8100-fca5dd418116 | DHCP agent         | sv3  | :-)   | True           | neutron-dhcp-agent        |
    | 51859f25-5091-4c7f-bbe3-930af75e94c2 | L3 agent           | sv1  | xxx   | True           | neutron-l3-agent          |
    | 7a73c26c-9b37-441a-929a-3f780bf4ad8b | Open vSwitch agent | sv3  | :-)   | True           | neutron-openvswitch-agent |
    | 7e3a5d26-5705-4a80-88e0-7d48806d450b | L3 agent           | sv2  | xxx   | True           | neutron-l3-agent          |
    | 9e1a3985-9e30-494e-a77b-e90e42eafa3d | DHCP agent         | sv1  | :-)   | True           | neutron-dhcp-agent        |
    | b732cb37-442f-4fba-9df8-c6f3c6dd08c9 | L3 agent           | sv3  | :-)   | True           | neutron-l3-agent          |
    | de627592-dba8-4884-9736-2088fd0b0063 | Metadata agent     | sv1  | xxx   | True           | neutron-metadata-agent    |
    | e67f5dfe-5cc5-46b0-bace-28fcb7a38c6a | Metadata agent     | sv3  | :-)   | True           | neutron-metadata-agent    |
    | f35153fd-98dd-4799-a22c-98487f5aaeee | Metadata agent     | sv2  | xxx   | True           | neutron-metadata-agent    |
    +--------------------------------------+--------------------+------+-------+----------------+---------------------------+
    ```

1. The `cinder service-list` should look as follows.

    ```
    $ cinder service-list
    +------------------+------+------+---------+-------+----------------------------+-----------------+
    |      Binary      | Host | Zone |  Status | State |         Updated_at         | Disabled Reason |
    +------------------+------+------+---------+-------+----------------------------+-----------------+
    | cinder-scheduler | sv1  | nova | enabled |   up  | 2015-09-06T04:14:12.000000 |       None      |
    | cinder-scheduler | sv2  | nova | enabled |   up  | 2015-09-06T04:14:09.000000 |       None      |
    | cinder-scheduler | sv3  | nova | enabled |   up  | 2015-09-06T04:14:15.000000 |       None      |
    |  cinder-volume   | sv1  | nova | enabled |   up  | 2015-09-06T04:14:13.000000 |       None      |
    +------------------+------+------+---------+-------+----------------------------+-----------------+
    ```

1. Run `./get-cirros-and-reg.sh` for get the VM image and register it.

1. Run `./create-sample-network.sh` for create the virtual network for the VM.

1. Sign in to the Dashboard `http://10.0.0.100/horizon/auth/login/` ID:PASS=`demo`:`openstack`.

## Restrictions

1. [Ceph] ceph-mds is not installed.

1. [Corosync/Pacemaker] Note the version of libqb0. 0.17 or higher is required.

## Memo

1. [Percona XtraDB] After the stop of all of cluster servers(sv1,sv2,sv3), you need to start the Percona XtraDB Cluster manually after the restart them as follows.

    ```
    vagrant@starter:~$ cd ~/percona-xtradb-cluster/
    vagrant@starter:~/percona-xtradb-cluster$ ./cold-start.sh
    ```

1. [RabbitMQ] When the entire cluster is brought down, the last node to go down must be the first node to be brought online. If this doesn't happen, the nodes will wait 30 seconds for the last disc node to come back online, and fail afterwards. If the last node to go offline cannot be brought back up, it can be removed from the cluster using the forget_cluster_node command - consult the rabbitmqctl manpage for more information. (see https://www.rabbitmq.com/clustering.html)

1. [RabbitMQ] If all cluster nodes stop in a simultaneous and uncontrolled manner (for example with a power cut) you can be left with a situation in which all nodes think that some other node stopped after them. In this case you can use the force_boot command on one node to make it bootable again - consult the rabbitmqctl manpage for more information. (see https://www.rabbitmq.com/clustering.html)

1. [OpenStack] If you want to remove all the OpenStack service logs, you can use `clear-logs.sh` as follows.

    ```
    vagrant@starter:~$ cd ~/openstack/
    vagrant@starter:~/openstack$ ./clear-logs.sh
    ```
