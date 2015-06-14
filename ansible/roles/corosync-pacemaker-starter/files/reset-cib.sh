#!/bin/bash
set -eux
ssh sv1 sudo service corosync stop
ssh sv2 sudo service corosync stop
ssh sv3 sudo service corosync stop
ssh sv1 sudo rm /var/lib/pacemaker/cib/*
ssh sv2 sudo rm /var/lib/pacemaker/cib/*
ssh sv3 sudo rm /var/lib/pacemaker/cib/*
