#!/bin/bash

set -a
    . .env
set +a

####### * INSTANCIAS RENES1 y RENES2 - DESTRUCCIÓN ########
echo "Borrando las instancias renes1 y renes2..."
osm ns-delete ${NSID1} > /dev/null
osm ns-delete ${NSID2} > /dev/null


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
