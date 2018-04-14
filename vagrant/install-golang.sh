#!/bin/bash -ex

yum install -y wget
wget https://dl.google.com/go/go1.10.1.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.10.1.linux-amd64.tar.gz

cp /vagrant/settings/goenv.sh /etc/profile.d/goenv.sh

source /etc/profile.d/goenv.sh

tee /root/hello.go <<-EOF
package main

import "fmt"

func main() {
    fmt.Printf("hello world!!!\n")
}
EOF

go run /root/hello.go
