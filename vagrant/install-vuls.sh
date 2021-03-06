#!/bin/bash -ex

yum install -y sqlite git gcc

mkdir -p /var/log/vuls
chown vagrant /var/log/vuls
chmod 700 /var/log/vuls

mkdir -p /root/vuls

tee /root/vuls/config.toml <<-EOF
[servers.127-0-0-1]
host    =       "127.0.0.1"
port    =       "22"
user    =       "vagrant"
keyPath =       "/home/vagrant/.ssh/id_rsa"
EOF

# install go-cve-dictionary
go get github.com/kotakanbe/go-cve-dictionary
# for i in `seq 2002 $(date +"%Y")`; do go-cve-dictionary fetchnvd -years $i; done
# for i in `seq 1998 $(date +"%Y")`; do go-cve-dictionary fetchjvn -years $i; done
for i in `seq 2018 $(date +"%Y")`; do go-cve-dictionary fetchnvd -years $i; done
for i in `seq 2018 $(date +"%Y")`; do go-cve-dictionary fetchjvn -years $i; done

go get github.com/kotakanbe/goval-dictionary

goval-dictionary fetch-redhat 7

# install vuls
go get github.com/future-architect/vuls

cd /root/vuls

# Setting up target servers for Vuls
vuls prepare

# Start Scanning
#vuls scan -cve-dictionary-dbpath=/root/vuls/cve.sqlite3
#vuls scan -lang=ja

# TUI
#vuls tui
