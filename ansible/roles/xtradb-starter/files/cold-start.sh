#!/bin/bash
set -eux
if [[ -a done ]]; then
  ssh sv1 sudo service mysql bootstrap-pxc
  ssh sv2 sudo service mysql start
  ssh sv3 sudo service mysql start
fi
