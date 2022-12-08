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

Nota: las variables OSMNS, ACCXPOD y CPEXPOD no se exportarán al environment. Si se necesitan, hay que conseguirlas a mano:
- OSMNS=7b2950d8-f92b-4041-9a55-8d1837ad7b0a
- kubectl -n $OSMNS get pods
    * CPE1POD=\<Primer ID>
    * ACC1POD=\<Segundo ID>
    * CPE2POD=\<Tercer ID>
    * ACC2POD=\<Cuarto ID>

### `vbstart.sh` script

Este script arranca las máquinas virtualbox. Ejecutar desde el **PC anfitrión**.

Para ello, comprueba si las máquinas virtuales están importadas y paradas, crea las carpetas compartidas y arranca las máquinas.

### `vnxstart.sh` script

Este script arranca los escenarios home y server VNX. Ejecutar desde **RDSV-K8S**

Para ello, aumenta lo límites inotify (max_user_instances) para evitar errores con DHCP, a través de VNX arranca los escenarios y permite acceso a las aplicaciones con entorno gráfico desde las máquinas arrancadas con VNX.

### `init.sh` script

Es el script principal. Ejecutar desde **RDSV-OSM**

TODO
