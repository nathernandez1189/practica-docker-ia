#!/bin/bash
set -euo pipefail
cd /Users/nataliahernandez/prueba
vagrant up servidorUbuntu clienteUbuntu --no-provision
vagrant ssh servidorUbuntu -c 'docker start webprueba webpersonal webcontainer webvolumen jupyter-ia ml-jupyter flask-practica'
vagrant ssh clienteUbuntu -c 'docker start webcliente'
open http://192.168.100.3:9001
open http://192.168.100.3:8888
printf '\nPara entrar a Jupyter, usa el token que aparece a continuación:\n'
vagrant ssh servidorUbuntu -c 'docker exec jupyter-ia jupyter server list'
printf '\nLaboratorio listo. Puedes cerrar esta ventana.\n'
