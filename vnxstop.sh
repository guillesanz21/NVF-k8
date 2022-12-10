#!/bin/bash

echo "Parando escenario de la práctica final de SDNV..."

echo "Parando los escenarios home a través de VNX..."
sudo vnx -f vnx/nfv3_home_lxc_ubuntu64.xml --destroy

echo "Parando el escenario server a través de VNX..."
sudo vnx -f vnx/nfv3_server_lxc_ubuntu64.xml --destroy

echo "Done"