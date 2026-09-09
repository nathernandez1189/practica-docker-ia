#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
exec > >(tee evidencias/ejercicio-volumenes.log) 2>&1
set -x
# Directorio del anfitrión Ubuntu compartido con Apache.
docker run -d --name webvolumen -p 192.168.100.3:9920:80 \
  --mount "type=bind,source=$PWD/volumenes,target=/var/www/html,readonly" practica/ubuntuweb:base
sleep 2
curl --fail http://192.168.100.3:9920
printf 'Cambio realizado desde el anfitrión Ubuntu\n' > volumenes/cambio.txt
curl --fail http://192.168.100.3:9920/cambio.txt | grep 'Cambio realizado'
docker inspect webvolumen --format '{{json .Mounts}}'
# Escritura del contenedor hacia el anfitrión.
docker run --rm --mount "type=bind,source=$PWD/volumenes,target=/datos" \
  practica/ubuntuweb:base sh -c 'echo "Archivo escrito desde un contenedor" > /datos/desde-contenedor.txt'
cat volumenes/desde-contenedor.txt
# Persistencia entre dos contenedores independientes.
docker volume create practica_ia_datos
docker run --rm --name escritor-persistencia \
  --mount source=practica_ia_datos,target=/datos practica/ubuntuweb:base \
  sh -c 'echo "Los datos sobreviven al contenedor" > /datos/evidencia.txt'
docker run --rm --name lector-persistencia \
  --mount source=practica_ia_datos,target=/datos,readonly practica/ubuntuweb:base \
  cat /datos/evidencia.txt | grep 'Los datos sobreviven'
docker volume inspect practica_ia_datos
