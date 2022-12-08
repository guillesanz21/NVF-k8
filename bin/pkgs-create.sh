#!/bin/bash

# Añadir paquetes a OSM Packages VNF y NS
echo "\nInstalando los descriptores (VNF y NS) en OSM..."
# VNF
VNFAccess=$(osm vnfpkg-list | grep -c access)
if [[ ${VNFAccess} -eq 0 ]]; then
    echo "... Instalando descriptor VNF Access"
    osm vnfpkg-create ./pck/accessknf_vnfd.tar.gz
fi
VNFCPE=$(osm vnfpkg-list | grep -c cpe)
if [[ ${VNFCPE} -eq 0 ]]; then
    echo "... Instalando descriptor VNF CPE"
    osm vnfpkg-create ./pck/cpeknf_vnfd.tar.gz
fi
# NS
NS=$(osm nspkg-list | grep -c renes)
if [[ ${NS} -eq 0 ]]; then
    echo "... Instalando descriptor NS RENES"
    osm nspkg-create ./pck/renes_ns.tar.gz
fi