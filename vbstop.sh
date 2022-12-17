#!/bin/bash


echo "Apagando las MVs..."
OSMState=$(vboxmanage showvminfo "RDSV-OSM" | grep -c "running (since")
K8SState=$(vboxmanage showvminfo "RDSV-K8S" | grep -c "running (since")
if [[ ${OSMState} -eq 0 ]]; then
    echo "La máquina virtual RDSV-OSM ya está apagada";
    exit 1;
fi
if [[ ${K8SState} -eq 0 ]]; then
    echo "La máquina virtual RDSV-K8S ya está apagada";
    exit 1;
fi

vboxmanage controlvm RDSV-OSM poweroff
vboxmanage controlvm RDSV-K8S poweroff