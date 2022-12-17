# Trabajo final de la asignatura SDNV (MUIRST - ETSIT - UPM)

Trabajo final de la asignatura SDNV del máster MUIRST de la escuela ETSIT de la Universidad Politécnica de Madrid (UPM).

## Documentación

En el fichero `doc/RDSV-p4.md` se encuentra el enunciado de la práctica previa a este trabajo, donde se enuncia el escenario de redes residenciales basado NFV, donde se utilizan kubernetes y la herramienta desarrollada por la ETSIT llamada VNX, que permite virtualizar varios componentes de la red.

En el fichero `doc/RDSV-final.md` se encuentran las recomendaciones a seguir para realizar este trabajo final.

En el fichero `doc/Enunciado.pdf` se encuentra el enunciado del trabajo.

## Guía de uso

0. OVA importado desde virtualbox.
1. Ejecutar `vbstart.sh` desde el **PC anfitrión**
2. Ejecutar desde **RDSV-K8S**:
    - `sudo vnx --modify-rootfs /usr/share/vnx/filesystems/vnx_rootfs_lxc_ubuntu64-20.04-v025-vnxlab/`
    - Hacer login con root/xxxx
    - `apt-get install iperf3`
    - `halt -p`
3. Ejecutar `vnxstart.sh` desde **RDSV-K8S**
4. Desde el **PC anfitrión**: `ssh -l upm 192.168.56.12  # password: xxxx`
5. Ejecutar `init.sh` desde **RDSV-OSM**
6. Ejecutar `source .env` dede **RDSV-OSM** para exportar al entorno las variables creadas en el script anterior.

Para parar el escenario y borrar todo lo relacionado con osm (instancias, descriptores, repo):
0. Ejecutar `source .env` dede **RDSV-OSM**. Si no se ha realizado antes.
1. Ejecutar `down.sh` desde **RDSV-OSM**.
2. Ejecutar `vnxstop.sh`desde **RDSV-K8S**.

### `vbstart.sh` script

Ejecutar desde el **PC anfitrión**.

Este script arranca las máquinas virtualbox. 

Para ello, comprueba si las máquinas virtuales están importadas y paradas, crea las carpetas compartidas y arranca las máquinas.

### `vnxstart.sh` script

Ejecutar desde **RDSV-K8S**

Este script arranca los escenarios home y server VNX. 

Para ello, aumenta lo límites inotify (max_user_instances) para evitar errores con DHCP, a través de VNX arranca los escenarios y permite acceso a las aplicaciones con entorno gráfico desde las máquinas arrancadas con VNX.

### `init.sh` script

Ejecutar desde **RDSV-OSM**

Es el script que configura OSM (instancias, descriptores, paquetes) y orquesta los pods de kubernetes KNF:ACCESS y KNF:CPE.

Para ello:
- Recupera la variable OSMNS (el namespace del cluster)
- Crea el repositorio HELM
- Añade los paquetes VNF y el paquete NS
- Crea las instancias de renes1 y renes2. Para cada instancia:
    - TODO (renes_start)
    - Configura el controlador SDN Ryu en KNF:ACCESS
    - TODO (renes_start)
- Configura QoS en los pods KNF:ACCESS
- Configura ARPWATCH en los pods KNF:CPE


### `vnxstop.sh` script

Ejecutar desde **RDSV-K8S**

Este script para los escenarios home y server VNX. 

### `down.sh` script

Ejecutar desde **RDSV-OSM**

Es el script que para todo lo relacionado con OSM (instancias, descriptores, paquetes).