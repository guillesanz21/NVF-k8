#!/bin/bash

export OSMNS  # needs to be defined in calling shell
if [[ -z ${OSMNS} ]]; then
    set -a
    . .env
    set +a
fi

if [[ -z ${1} ]]; then
    echo "ksh [CPE1, CPE2, ACC1, ACC2]"
else
    POD=$(eval echo \${${1}POD})
    kubectl exec -n $OSMNS -it ${POD} -- /bin/bash
fi
