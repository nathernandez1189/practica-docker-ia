#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 || ! "$1" =~ ^[a-z0-9][a-z0-9_-]{2,29}$ ]]; then
  echo 'Uso: bash scripts/publicar-dockerhub.sh TU_USUARIO_DOCKERHUB'; exit 1
fi
usuario="$1"
# La autenticación se realiza interactivamente; no guardar claves en este archivo.
docker login
docker tag practica/ubuntuweb:base "$usuario/ubuntuweb:v1"
docker tag practica/sitio-docker:v1 "$usuario/sitio-docker:v1"
docker push "$usuario/ubuntuweb:v1"
docker push "$usuario/sitio-docker:v1"
printf 'En clienteUbuntu descargar: docker pull %s/ubuntuweb:v1\n' "$usuario"
printf 'Si webcliente ya existe, detener y retirar solo ese contenedor de la práctica antes de recrearlo.\n'
printf 'docker run -d --name webcliente -p 192.168.100.2:9900:80 %s/ubuntuweb:v1\n' "$usuario"
