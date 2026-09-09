#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p evidencias
exec > >(tee evidencias/03-04-06-web.log) 2>&1
set -x
hostname
date -Iseconds
docker search apache --limit 5
docker pull httpd:2.4
docker images
docker run -d --name web1 -p 192.168.100.3:8800:80 httpd:2.4
sleep 2
curl --fail http://192.168.100.3:8800
docker ps
docker stop web1
docker rm web1
docker container ls -a
docker search ubuntu --limit 5
docker build -t practica/ubuntuweb:base ./test_docker
docker tag practica/ubuntuweb:base practica/ubuntuweb:v1
docker run -d --name webprueba -p 192.168.100.3:9000:80 practica/ubuntuweb:base
docker build -t practica/sitio-docker:v1 ./sitio-personalizado
docker run -d --name webpersonal -p 192.168.100.3:9001:80 practica/sitio-docker:v1
docker build -t practica/testdir:v1 ./test_docker2
docker run -d --name webcontainer -p 192.168.100.3:9910:80 practica/testdir:v1
sleep 2
curl --fail http://192.168.100.3:9000
curl --fail http://192.168.100.3:9001
curl --fail http://192.168.100.3:9910
curl --fail http://192.168.100.3:9910/pagina1.html
docker logs webcontainer
docker exec webcontainer bash -c 'hostname; ls -l /var/www/html; apache2ctl -v'
docker ps
