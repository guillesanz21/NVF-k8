#!/bin/bash

echo "Iniciando escenario de la práctica final de SDNV..."

echo "Aumentando los límites inotify --> max user instances de 128 a 512"
# Para evitar problemas con DHCP
sudo sysctl fs.inotify.max_user_instances=512

echo "Creando los escenarios home a través de VNX..."
sudo vnx -f vnx/nfv3_home_lxc_ubuntu64.xml -t

echo "Creando el escenario server a través de VNX..."
sudo vnx -f vnx/nfv3_server_lxc_ubuntu64.xml -t

echo "Permitiendo acceso a las aplicaciones con entorno grafico desde las máquinas arrancadas con VNX"
xhost +

echo "Done"