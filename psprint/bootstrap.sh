#!/usr/bin/env zsh

sudo DEBIAN_FRONTEND=noninteractive apt install --yes cmake redis-server libhiredis-dev \
                        tree gem libfreetype6-dev libfontconfig-dev \
                        autoconf automake nodejs npm

# For zdharma/zredis
sudo mkdir -p usr/local/var/db/redis

# Install exa for ls aliases – currently not needed as
# it is installed via zplugin
#cargo install exa
