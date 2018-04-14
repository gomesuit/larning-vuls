#!/bin/bash -ex

vagrant up

SSH_CONFIG=$(vagrant ssh-config)
cat config.sample.toml | \
  sed "s/HOST/$(echo "$SSH_CONFIG" | grep HostName | awk '{print $2}')/g" | \
  sed "s/PORT/$(echo "$SSH_CONFIG" | grep Port | awk '{print $2}')/g" | \
  sed "s/USER/$(echo "$SSH_CONFIG" | grep 'User ' | awk '{print $2}')/g" \
  > config.toml

# Pull new vuls docker images
docker pull vuls/go-cve-dictionary
docker pull vuls/vuls

# config check
# docker run --rm \
#   -v ~/.ssh:/root/.ssh:ro \
#   -v $PWD:/vuls \
#   -v $PWD/vuls-log:/var/log/vuls \
#   vuls/vuls configtest \
#   -config=./config.toml \

# Fetch NVD
for i in {2002..2017}; do \
  docker run --rm \
  -v $PWD/work:/vuls \
  -v $PWD/work/go-cve-dictionary-log:/var/log/vuls \
  vuls/go-cve-dictionary fetchnvd -years $i; \
done
for i in {2002..2017}; do \
  docker run --rm \
  -v $PWD/work:/vuls \
  -v $PWD/work/go-cve-dictionary-log:/var/log/vuls \
  vuls/go-cve-dictionary fetchjvn -years $i; \
done

# Fetch OVAL
docker run --rm \
  -v $PWD/work:/vuls \
  -v $PWD/work/goval-dictionary-log:/var/log/vuls \
  vuls/goval-dictionary fetch-redhat 5 6 7

# echo "remove known_hosts"
# ssh-keygen -R $PRIVATE_IP || true
# sleep 5

# echo "add known_hosts"
# ssh-keyscan $PRIVATE_IP >> ~/.ssh/known_hosts

# scan
docker run --rm \
  -v ~/.ssh:/root/.ssh:ro \
  -v $(echo "$SSH_CONFIG" | grep IdentityFile | awk '{print $2}'):/root/.ssh/private_key:ro \
  -v $PWD/work:/vuls \
  -v $PWD/work/vuls-log:/var/log/vuls \
  -v $PWD/config.toml:/vuls/config.toml \
  -v /etc/localtime:/etc/localtime:ro \
  -e "TZ=Asia/Tokyo" \
  vuls/vuls scan \
  -ssh-native-insecure \
  -config=./config.toml

# report
docker run --rm \
  -v ~/.ssh:/root/.ssh:ro \
  -v $(echo "$SSH_CONFIG" | grep IdentityFile | awk '{print $2}'):/root/.ssh/private_key:ro \
  -v $PWD/work:/vuls \
  -v $PWD/work/vuls-log:/var/log/vuls \
  -v $PWD/config.toml:/vuls/config.toml \
  -v /etc/localtime:/etc/localtime:ro \
  vuls/vuls report \
  -lang=ja \
  -cvss-over=7.0 \
  -cvedb-path=/vuls/cve.sqlite3 \
  -ovaldb-path=/vuls/oval.sqlite3 \
  -format-short-text \
  -config=./config.toml \
  -to-slack
