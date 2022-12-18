#!/bin/bash

export OSMNS  # needs to be defined in calling shell
if [[ -z ${OSMNS} ]]; then
    set -a
    . .env
    set +a
fi

if [[ -z ${1} ]]; then
    echo "arpwatch_show [CPE1, CPE2]"
else
    POD=$(eval echo \${${1}POD})
    kubectl exec -n $OSMNS -it ${POD} -- arpwatch -d
fi
