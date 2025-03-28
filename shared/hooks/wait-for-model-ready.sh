#!/bin/bash

MODEL="$1"

if [ -z "$MODEL" ]; then
    echo "Wait for the model to be ready."
    echo ""
    echo "Usage: $0 <MODEL>"
    exit 1
fi

juju wait-for model $MODEL --query='forEach(applications, app => app.status == "active")'
