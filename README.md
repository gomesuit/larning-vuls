# vagrant-vuls

cd /root/vuls
go-cve-dictionary fetchjvn -week
vuls prepare
vuls scan -cve-dictionary-dbpath=/root/vuls/cve.sqlite3

vuls tui
