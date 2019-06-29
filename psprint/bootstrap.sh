#!/usr/bin/env zsh

sudo apt install --yes cmake redis-server libhiredis-dev

# For zdharma/zredis
sudo mkdir -p usr/local/var/db/redis

# Install exa for ls aliases – currently not needed as
# it is installed via zplugin
#cargo install exa
