#!/bin/bash

set -u # to verify variables are defined
: $ACC_EXEC
: $CPE_EXEC

#### * CONTROLADOR RYU ####
# He seguido los pasos de: http://osrg.github.io/ryu-book/en/html/rest_qos.html
# y de: https://github.com/giros-dit/vnx-qos-ryu#quick-guide
echo "  ... Configurando y arrancando el controlador Ryu..."
## 1. Configuración RYU
# El siguiente comando daba un "permission denied", asi que se ha movido al Dockerfile
# $ACC_EXEC sudo sed '/OFPFlowMod(/,/)/s/)/, table_id=1)/' usr/lib/python3/dist-packages/ryu/app/simple_switch_13.py > /home/qos_simple_switch_13.py
$ACC_EXEC ovs-vsctl set bridge brint protocols=OpenFlow10,OpenFlow12,OpenFlow13
# $ACC_EXEC ovs-vsctl set-fail-mode brint secure
# $ACC_EXEC ovs-vsctl set bridge brint other-config:datapath-id=0000000000000001
# $ACC_EXEC ovs-vsctl set-controller brint tcp:127.0.0.1:6633
$ACC_EXEC ovs-vsctl set-manager ptcp:6632
## 2. Arranque RYU
$ACC_EXEC ryu-manager ryu.app.rest_qos /home/qos_simple_switch_13.py ryu.app.rest_conf_switch &


#### * QoS ####
## 3. Comprobar que se han asignado las IPs correspondientes y recuperarlas
DHCP_LEASE_LIST=$($CPE_EXEC dhcp-lease-list --parsable)
hx1entry=$(echo "${DHCP_LEASE_LIST}" | grep -E -i "HOSTNAME h(1|2)1")
hx2entry=$(echo "${DHCP_LEASE_LIST}" | grep -E -i "HOSTNAME h(1|2)2")
IPhx1=""
IPhx2=""
while [[ -z IPhx1 || -z IPhx2 ]]; do
    echo "Por favor, ejecute 'dhclient eth1' en h11, h12, h21 y h22"
    read -p "Pulse enter cuando tengan asignada una IP"
    IPhx1=$(echo "${hx1entry}" | awk '{split($0,a,"IP ");split(a[2],b," HOSTNAME");print b[1]}')
    IPhx2=$(echo "${hx1entry}" | awk '{split($0,a,"IP ");split(a[2],b," HOSTNAME");print b[1]}')
done

echo "IP Hx1: ${IPhx1}"
echo "IP Hx2: ${IPhx2}"

## 4. Configuración de la QoS
$ACC_EXEC curl -X PUT -d '"tcp:127.0.0.1:6632"' http://127.0.0.1:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr
# Tráfico bajada
$ACC_EXEC curl -X POST -d '{"port_name": "vxlanacc", "type": "linux-htb", "max_rate": "12000000", "queues": [{"min_rate": "8000000"}, {"max_rate": "4000000"}]}' http://localhost:8080/qos/queue/0000000000000001
$ACC_EXEC curl -X POST -d '{"match": {"nw_dst": "'$IPhx1'"}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/0000000000000001
$ACC_EXEC curl -X POST -d '{"match": {"nw_dst": "'$IPhx2'"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001

# Tráfico subida
# $ACC_EXEC curl -X POST -d '{"port_name": "vxlanint", "type": "linux-htb", "max_rate": "6000000", "queues": [{"min_rate": "4000000"}, {"max_rate": "2000000"}]}' http://localhost:8080/qos/queue/0000000000000001

# $ACC_EXEC curl -X POST -d '{"match": {"nw_src": "'$IPhx1'"}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/0000000000000001
# $ACC_EXEC curl -X POST -d '{"match": {"nw_src": "'$IPhx2'"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001




# TODO: Para el tráfico de subida, mirar dos opciones: configurar QoS en el switch ryu con "port_name": "vxlanint", o configurar en brg1:

# TODO OPCIÓN: brg1: QoS. Probablemente haga falta meter los comandos en el lxc_ubuntu.xml
# De LXC:
# ovs-vsctl add-br br0
# ovs-vsctl add-port br0 eth1
# ovs-vsctl add-port br0 vxlan1 -- set interface vxlan1 type=vxlan options:remote_ip=10.255.0.1

# Probar:
# ovs-vsctl set-manager ptcp:6632
# curl -X PUT -d '"tcp:127.0.0.1:6632"' http://10.255.0.1:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr
# curl -X POST -d '{"port_name": "vxlan1", "type": "linux-htb", "max_rate": "6000000", "queues": [{"min_rate": "4000000"}, {"max_rate": "2000000"}]}' http://localhost:8080/qos/queue/0000000000000001
# curl -X POST -d '{"match": {????????????}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/0000000000000001
# curl -X POST -d '{"match": {????????????}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001




# MAC H11 "dl_src": "02:fd:00:04:00:01"
# MAX H12 "dl_src": "02:fd:00:04:01:01"

# Para la red residencial: 12 Mbps de bajada (y 6 Mbps de subida)
# § Para hX1: 8 Mbps mínimo de bajada (y 4 Mbps mínimo de subida)
# § Para hX2: 4 Mbps máximo de bajada (y 2 Mbps máximo de subida)