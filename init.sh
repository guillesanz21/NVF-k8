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
KID="a1337fb3-21d9-4952-bf58-8265b750f4d0"     #  Es siempre el mismo valor.
# Se asigna automáticamente para acelerar el despliegue. El siguiente comando lo recupera automáticamente:
# KID=$(osm k8scluster-list --literal | grep _id | awk '{split($0,a,": ");print a[2]}')
exportVar KID ${KID}

# Namespace cluster - Asignar valor a OSMNS:
OSMNS="7b2950d8-f92b-4041-9a55-8d1837ad7b0a"   #  Es siempre el mismo valor.
# Se asigna automáticamente para acelerar el despliegue. El siguiente comando lo recupera automáticamente:
# OSMNS=$(osm k8scluster-show --literal $KID | grep -A1 projects_read | awk '{split($0,a,"- ");print a[2]}')
exportVar OSMNS ${OSMNS}

####### * PASOS PRELIMINARES #######
# Crear K8s repos con info helm
./bin/helmrepo.sh
# Añadir paquetes a OSM Packages VNF y NS
./bin/pkgs-create.sh

sleep 5

####### * INSTANCIAS RENES1 y RENES2 - CREACIÓN Y CONFIGURACIÓN ########
./bin/renes1.sh
./bin/renes2.sh


echo "PRÁCTICA FINAL SDNV - GUILLERMO SANZ GONZÁLEZ"
