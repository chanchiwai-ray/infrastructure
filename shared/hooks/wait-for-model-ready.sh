#!/bin/bash

MODEL="$1"
TIMEOUT="${2:-5m0s}"
RETRIES="${3:-5}"

if [ -z "$MODEL" ]; then
    echo "Wait for the model to be ready."
    echo ""
    echo "Usage: $0 <MODEL> [TIMEOUT=10m0s] [RETRIES=5]"
    exit 1
fi

count=0
while [ $count != $RETRIES ] ; do
    echo retry counts: $count
    count=$((count+1))
    if juju wait-for model $MODEL --timeout=$TIMEOUT --query='forEach(applications, app => app.status == "active")'; then
        exit 0
    fi
done
