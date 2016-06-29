#!/bin/sh

ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
chown vagrant.vagrant -R /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
