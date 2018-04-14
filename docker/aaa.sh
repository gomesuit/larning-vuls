#!/bin/bash -e

SSH_CONFIG=$(vagrant ssh-config)

cat config.sample.toml | \
  sed "s/HOST/$(echo "$SSH_CONFIG" | grep HostName | awk '{print $2}')/g" | \
  sed "s/PORT/$(echo "$SSH_CONFIG" | grep Port | awk '{print $2}')/g" | \
  sed "s/USER/$(echo "$SSH_CONFIG" | grep 'User ' | awk '{print $2}')/g" | \
  sed "s@KEY_PATH@$(echo "$SSH_CONFIG" | grep IdentityFile | awk '{print $2}')@g" \
  > config.toml
