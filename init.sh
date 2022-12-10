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

# 1. Repasar prácticas 2.1 y 2.2
#   1.1. Analizar opciones de ryu. Como añadir reglas y todo eso.
#   1.2. Simultaneamente tener en el portatil la practica 2.1 y en este PC la practica final
# 2. Configurar ryu (Openflow) en KNF:access (kubctl) y tratar de automatizar los pasos en este script
#   2.1. Arrancar ryu con el script que hice para 2.2
#   2.2. Probar conectividad con ping entre h11 y servidor
#   2.3. Arrancar whireshark en RDSV-K8S y analizar interfaces correspondientes
#   2.4. Analizar tablas de flujos
# 3. ARPWATCH en KNF:CPE
#   3.1. Enterarse de que es ARPWATCH y como funciona
#   3.2. Desde kubtcl ir probando el comando
#   3.3. Configurarlo y automatizarlo en este script
# 4. Repasar práctica 2.4 (QoS).
#   4.1. En el portatil y luego tener simultaneamente ambos PCs
#   4.2. Con kubctl realizar los cambios
#   4.3. Testear con iperf desde h11 hacia ¿h21?
#   4.4. Automatizar

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
