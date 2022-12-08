#!/bin/bash

maxSecondsWaiting=80
secondsInterval=4
maxWaitingCycles=$(( $maxSecondsWaiting / $secondsInterval ))

STATUS=""

function exportVar () {
    export "${1}"=${2}
    echo $1=\"${2}\" >> ../.env
}


####### * CREACIÓN DE INSTANCIA ########
echo "\nCreando instancia RENES 2..."
function renes2 () {
    ### Creación de instancia de servicio
    NSID2=$(osm ns-create --ns_name renes2 --nsd_name renes --vim_account dummy_vim)

    ### Recuperar status de la instancia
    STATUS=$(osm ns-show renes2 --literal | grep nsState | awk '{i++}i==2' | awk '{split($0,a,":");print a[2]}')   
    count=1
    while [[ "$STATUS" =~ .*"BUILDING".* && count -lt maxWaitingCycles ]]; do
        echo "...Esperando a que la instancia renes2 esté completamente operativa..."
        STATUS=$(osm ns-show renes2 --literal | grep nsState | awk '{i++}i==2' | awk '{split($0,a,":");print a[2]}')
        sleep ${secondsInterval}
        count=$((count+1))
    done
}
renes2
if [[ "$STATUS" =~ .*"BUILDING".* || "$STATUS" =~ .*"BROKEN".* ]]; then
    echo "...La instancia renes2 no se ha podido crear."
    echo "...Intentándolo por última vez..."
    renes2 
fi
if [[ "$STATUS" =~ .*"BUILDING".* || "$STATUS" =~ .*"BROKEN".* ]]; then
    echo "No se ha podido crear la instancia renes2. Terminando el proceso..."
    exit 1
elif [[ "$STATUS" =~ .*"READY".* ]]; then
    echo "La instancia renes2 se ha creado con éxito"
else 
    echo "La instancia renes2 está en un estado desconocido: ${STATUS}. Terminando el proceso..."
    exit 1
fi

exportVar NSID2 $NSID2

####### * OBTENER PODS ########
# CPE
CPE2POD=$(kubectl -n $OSMNS get pods | grep helmchartrepo-cpechart | tail -1 | awk '{print $1}')
# ACCESS
ACC2POD=$(kubectl -n $OSMNS get pods | grep helmchartrepo-accesschart | tail -1 | awk '{print $1}')

exportVar CPE2POD $CPE2POD
exportVar ACC2POD $ACC2POD

####### * CONFIGURACIÓN INSTANCIA ########
./osm_renes2.sh