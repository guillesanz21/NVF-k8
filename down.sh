#!/bin/bash

set -a
    . .env
set +a

####### * INSTANCIAS RENES1 y RENES2 - DESTRUCCIÓN ########
echo "Borrando las instancias renes1 y renes2..."
function forceDelete() {
    osm ns-delete --force renes1 > /dev/null
    osm ns-delete --force renes2 > /dev/null
}
function getNS() {
    renes=$(osm ns-list | grep renes)
}
if [[ "${1}" == "--force" ]]; then
    getNS
    while [[ ! -z "${renes}" ]]; do
        forceDelete
        sleep 3
        getNS
    done

else
    osm ns-delete ${NSID1} > /dev/null
    osm ns-delete ${NSID2} > /dev/null
fi


####### * PAQUETES / DESCRIPTORES OSM - BORRADO #######
echo "Borrando el descriptor NS renes..."
osm nspkg-delete renes > /dev/null
echo "Borrando los descriptores VNF cpe y access..."
osm vnfpkg-delete cpeknf > /dev/null
osm vnfpkg-delete accessknf > /dev/null

####### * REPO K8 HELM - BORRADO #######
echo "Borrando el repo helm..."
osm repo-delete helmchartrepo > /dev/null

echo "Done"
