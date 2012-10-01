#!/bin/bash

# Usage: ./deploy.sh

host=`cat credentials`

# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
ssh-keygen -R "${host#*@}" 2> /dev/null

tar cj . | ssh -o 'StrictHostKeyChecking no' "$host" '
sudo rm -rf /tmp/chef &&
mkdir /tmp/chef &&
cd /tmp/chef &&
tar xj &&
sudo bash install.sh'
