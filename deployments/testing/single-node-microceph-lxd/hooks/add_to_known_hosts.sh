#!/usr/bin/env bash

set -eou pipefail

node=$("$TG_CTX_TF_PATH" output -raw node)

if [[ -z "$node" ]]; then
    exit 0
fi

ssh-keyscan -H $node >> $HOME/.ssh/known_hosts
echo "Added $node to $HOME/.ssh/known_hosts"
