#!/bin/bash

export OSMNS  # needs to be defined in calling shell

maxSecondsWaiting=80
secondsInterval=4
maxWaitingCycles=$(( $maxSecondsWaiting / $secondsInterval ))

STATUS=""

function exportVar () {
    export "${1}"=${2}
    echo $1=\"${2}\" >> .env
}


####### * CREACIÓN DE INSTANCIA ########
echo "\nCreando instancia RENES 1..."
function renes1 () {
    ### Creación de instancia de servicio
    NSID1=$(osm ns-create --ns_name renes1 --nsd_name renes --vim_account dummy_vim)

    ### Recuperar status de la instancia
    STATUS=$(osm ns-show ${NSID1} --literal | grep nsState | awk '{i++}i==2' | awk '{split($0,a,":");print a[2]}')   
    count=1
    while [[ "$STATUS" =~ .*"BUILDING".* && count -lt maxWaitingCycles ]]; do
        echo "...Esperando a que la instancia renes1 esté completamente operativa..."
        STATUS=$(osm ns-show ${NSID1} --literal | grep nsState | awk '{i++}i==2' | awk '{split($0,a,":");print a[2]}')
        sleep ${secondsInterval}
        count=$((count+1))
    done
}
function deleteRenes1 () {
    STATUS=""
    osm ns-delete ${NSID1}
}
renes1
if [[ "$STATUS" =~ .*"BUILDING".* || "$STATUS" =~ .*"BROKEN".* ]]; then
    echo "...La instancia renes1 no se ha podido crear."
    echo "...Intentándolo por última vez..."
    deleteRenes1
    renes1 
fi
if [[ "$STATUS" =~ .*"BUILDING".* || "$STATUS" =~ .*"BROKEN".* ]]; then
    echo "No se ha podido crear la instancia renes1. Terminando el proceso..."
    deleteRenes1
    exit 1
elif [[ "$STATUS" =~ .*"READY".* ]]; then
    echo "La instancia renes1 se ha creado con éxito"
else 
    echo "La instancia renes1 está en un estado desconocido: ${STATUS}. Terminando el proceso..."
    deleteRenes1
    exit 1
fi

exportVar NSID1 $NSID1

####### * OBTENER PODS ########
# CPE
CPE1POD=$(kubectl -n ${OSMNS} get pods | grep helmchartrepo-cpechart | tail -1 | awk '{print $1}')
# ACCESS
ACC1POD=$(kubectl -n ${OSMNS} get pods | grep helmchartrepo-accesschart | tail -1 | awk '{print $1}')

exportVar CPE1POD $CPE1POD
exportVar ACC1POD $ACC1POD

####### * CONFIGURACIÓN INSTANCIA ########
./osm_renes1.sh