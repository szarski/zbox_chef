installation
============

create a new user:

    sudo adduser chefclient

open up `/etc/sudoers` and add:

    chefclient ALL=(ALL:ALL) NOPASSWD: ALL

on your computer run:

    echo "chefclient@hostname" > credentials
    ./deploy.sh
