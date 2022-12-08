#!/bin/bash

# Fichero .env con las variables
if [[ -f ".env" ]]; then
    rm .env 2> /dev/null
fi
function exportVar () {
    export "${1}"=${2}
    echo $1=\"${2}\" >> .env
}

####### * CLUSTER #######
# ID cluster - Asignar valor a KID:
exportVar KID a1337fb3-21d9-4952-bf58-8265b750f4d0     # Parece que siempre es el mismo
# Si se ve que cambia, recuperar el campo de: osm k8scluster-list

# Namespace cluster - Asignar valor a OSMNS:
exportVar OSMNS 7b2950d8-f92b-4041-9a55-8d1837ad7b0a    # Parece que siempre es el mismo
# Si se ve que cambia, recuperar el campo de: osm k8scluster-show --literal $KID | grep -A1 projects

####### * PASOS PRELIMINARES #######
# Crear K8s repos con info helm
./bin/helmrepo.sh
# Añadir paquetes a OSM Packages VNF y NS
./bin/pkgs-create.sh

####### * INSTANCIAS RENES1 y RENES2 - CREACIÓN Y CONFIGURACIÓN ########
./bin/renes1.sh
./bin/renes2.sh

# TODO:

# IP LINKS

# root@helmchartrepo-accesschart-0039730356-76f9f6b8f9-2jjt2:/# ip -d link show vxlanacc
# 7: vxlanacc: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UNKNOWN mode DEFAULT group default qlen 1000
#     link/ether 36:54:46:f8:1c:0a brd ff:ff:ff:ff:ff:ff promiscuity 1 minmtu 68 maxmtu 65535 
#     vxlan id 0 remote 10.255.0.2 dev net1 srcport 0 0 dstport 4789 ttl auto ageing 300 udpcsum noudp6zerocsumtx noudp6zerocsumrx 
#     openvswitch_slave addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
# root@helmchartrepo-accesschart-0039730356-76f9f6b8f9-2jjt2:/# ip -d link show vxlanint 
# 8: vxlanint: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UNKNOWN mode DEFAULT group default qlen 1000
#     link/ether da:0c:5b:a8:7e:5a brd ff:ff:ff:ff:ff:ff promiscuity 1 minmtu 68 maxmtu 65535 
#     vxlan id 1 remote 10.1.77.31 dev net1 srcport 0 0 dstport 8742 ttl auto ageing 300 udpcsum noudp6zerocsumtx noudp6zerocsumrx 
#     openvswitch_slave addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
