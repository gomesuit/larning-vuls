#!/bin/sh

yum install -y wget
wget https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.6.2.linux-amd64.tar.gz

tee /etc/profile.d/goenv.sh <<-EOF
export GOROOT=/usr/local/go
export GOPATH=\$HOME/go
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
EOF

source /etc/profile.d/goenv.sh

tee /root/hello.go <<-EOF
package main
 
import "fmt"
 
func main() {
    fmt.Printf("hello world!!!\n")
}
EOF

go run /root/hello.go
