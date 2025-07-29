#!/usr/bin/env bash

set -eou pipefail

node=$("$TG_CTX_TF_PATH" output -raw node)
echo "Bootstrapping microceph cluster..."
ssh ubuntu@$node -- sudo microceph cluster bootstrap

echo "Adding disks..."
ssh ubuntu@$node -- sudo microceph disk add --all-available --wipe

echo "Bootstrap completed"
