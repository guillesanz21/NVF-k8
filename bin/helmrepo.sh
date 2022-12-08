#!/bin/bash

# Crear K8s repos con info helm
echo "\nRegistrando el repositorio de helm charts..."
REPOHELM=$(osm repo-list | grep -c helmchartrepo)
if [[ ${REPOHELM} -eq 0 ]]; then
    echo "... Registrando repositorio helmchartrepo"
    osm repo-add --type helm-chart --description "Repo para la práctica final de RDSV" helmchartrepo https://guillesanz21.github.io/repo-rdsv
fi