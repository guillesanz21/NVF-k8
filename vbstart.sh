#!/bin/bash

## Comprobando si las MVs existen y están activas
echo "Comprobando si las MVs existen y si no están activas..."

OSMExists=$(vboxmanage list vms | grep -c OSM)
K8SExists=$(vboxmanage list vms | grep -c K8S)
if [[ ${OSMExists} -eq 0 ]]; then
    echo "La máquina virtual RDSV-OSM no se ha importado aún";
    exit 1;
fi
if [[ ${K8SExists} -eq 0 ]]; then
    echo "La máquina virtual RDSV-K8S no se ha importado aún";
    exit 1;
fi

OSMState=$(vboxmanage showvminfo "RDSV-OSM" | grep -c "running (since")
K8SState=$(vboxmanage showvminfo "RDSV-K8S" | grep -c "running (since")
if [[ ${OSMState} -eq 1 ]]; then
    echo "La máquina virtual RDSV-OSM ya está activa";
    exit 1;
fi
if [[ ${K8SState} -eq 1 ]]; then
    echo "La máquina virtual RDSV-K8S ya está activa";
    exit 1;
fi

echo "Las máquinas virtuales están importadas y paradas, continuando ejecución del script..."

## Shared folders
echo "Creando las carpetas compartidas..."
# Elimina (si existen) las carpetas compartidas
vboxmanage sharedfolder remove RDSV-OSM --name shared 2> /dev/null
vboxmanage sharedfolder remove RDSV-K8S --name shared 2> /dev/null
# Crea las carpetas compartidas
vboxmanage sharedfolder add RDSV-OSM --name shared --hostpath /home/guille/master/sdnv --automount --auto-mount-point /home/upm/shared
vboxmanage sharedfolder add RDSV-K8S --name shared --hostpath /home/guille/master/sdnv --automount --auto-mount-point /home/upm/shared


## Iniciar MVs
echo "Iniciando las máquinas virtuales..."

vboxmanage startvm RDSV-OSM --type headless # arrancar sin interfaz gráfica
vboxmanage startvm RDSV-K8S

echo "Done"