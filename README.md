# Práctica Docker e IA — Natalia Hernández

Implementación de la guía **2025-03 Practica Docker_IA.docx**, del profesor Oscar H. Mondragón. Los resultados reales y las evidencias de publicación se recogen en [el informe](docs/INFORME.md) y en `evidencias/`. **14 comprobaciones aprobadas.**

## Entrega y publicaciones

- [Repositorio GitHub privado](https://github.com/nathernandez1189/practica-docker-ia) · [Historial de commits](https://github.com/nathernandez1189/practica-docker-ia/commits/main/)
- [Imagen de prueba: nathernandez/ubuntuweb:v1](https://hub.docker.com/r/nathernandez/ubuntuweb)
- [Sitio personalizado: nathernandez/sitio-docker:v1](https://hub.docker.com/r/nathernandez/sitio-docker)
- [Informe PDF](docs/Informe-Practica-Docker-IA.pdf) · [Informe Word](docs/Informe-Practica-Docker-IA.docx)

Las imágenes publicadas son Linux ARM64. En clienteUbuntu se descargaron ambas desde Docker Hub; el servicio visible en el puerto 9900 usa actualmente `nathernandez/sitio-docker:v1`. Los originales de los repositorios de referencia se incluyen como copias de sus archivos; sus URLs y commits de origen se conservan en `evidencias/repositorios.json`.

## Abrir el laboratorio en este Mac

Las máquinas usadas ya existían y pertenecen al entorno `/Users/nataliahernandez/prueba`. El proyecto se conserva en `/Users/nataliahernandez/Documents/Proyectos-IA/practica-docker-ia` y en `/home/vagrant/practica-docker-ia` dentro del servidor.

```bash
cd /Users/nataliahernandez/prueba
vagrant up servidorUbuntu clienteUbuntu --no-provision
vagrant ssh servidorUbuntu
cd /home/vagrant/practica-docker-ia
docker start webprueba webpersonal webcontainer webvolumen jupyter-ia ml-jupyter flask-practica
```

`--no-provision` evita repetir el aprovisionamiento de trabajos anteriores. **No ejecutar `vagrant up` en la nueva carpeta del proyecto en este Mac**: su Vagrantfile reproduce la guía para una instalación independiente; las dos máquinas existentes ya usan esas IP.

| Servicio | Dirección desde el Mac |
| --- | --- |
| Página exacta de la parte 4 | http://192.168.100.3:9000 |
| Sitio personalizado | http://192.168.100.3:9001 |
| Copia de archivos, parte 6 | http://192.168.100.3:9910 |
| Directorio compartido | http://192.168.100.3:9920 |
| Jupyter / Iris | http://192.168.100.3:8888 |
| Notebooks del repositorio adaptado | http://192.168.100.3:8890 |
| Desafío Flask | http://192.168.100.3:5000 |
| Cliente con el sitio personalizado descargado de Docker Hub | http://192.168.100.2:9900 |

Jupyter requiere el token generado por el servidor. Consultarlo dentro de Ubuntu:

```bash
docker exec jupyter-ia jupyter server list
docker exec ml-jupyter jupyter server list
```

Usar la IP `192.168.100.3` y los puertos de la tabla con el token correspondiente. Los tokens no se incluyen en el paquete de entrega.

## Estructura

- `Vagrantfile`: las dos máquinas e IP de la guía.
- `scripts/instalar-docker-ubuntu.sh`: instalación oficial de Docker CE en Ubuntu 22.04.
- `test_docker/`: Apache y página exacta «Bienvenidos al servidor de prueba».
- `test_docker2/`: `COPY` de `voldocker`, con dos páginas enlazadas.
- `sitio-personalizado/`: imagen web personalizada.
- `data-science/`: Jupyter, TensorFlow, scikit-learn y notebook de clasificación Iris.
- `volumenes/`: archivos del ejemplo de directorio compartido.
- `referencias/`: repositorios del profesor descargados sin cambios.
- `ml-jupyter-compatible/`: Dockerfile y notebooks del repositorio adaptados a ARM64 y APIs vigentes.
- `flask/`: Dockerfile que ejecuta el código original de `omondragon/docker-flask-example`.
- `evidencias/`: registros, capturas y resultados reales.
- `docs/`: informe y explicación de las adaptaciones.

## Reproducir desde cero en dos máquinas nuevas

1. En un equipo sin máquinas que ya usen las IP de esta práctica, ejecutar `vagrant up` desde la carpeta del Vagrantfile.
2. Instalar Docker en cada Ubuntu: `sudo bash scripts/instalar-docker-ubuntu.sh`. Volver a entrar para activar el grupo `docker`.
3. Copiar el proyecto al servidor y situarse en su carpeta.
4. Ejecutar en orden `bash scripts/ejecutar-web.sh`, `bash scripts/probar-volumenes.sh` y `bash scripts/ejecutar-ia-flask.sh`.
5. Publicar las imágenes mediante `bash scripts/publicar-dockerhub.sh TU_USUARIO_DOCKERHUB` y probar la descarga desde el cliente como indica el script.

Los scripts de construcción usan los nombres de contenedor de la práctica y están pensados para la primera ejecución. Para retomar una instalación existente se usa `docker start`; repetir la creación con el mismo nombre produce un conflicto y no elimina datos automáticamente.

## Apagar sin perder datos

Desde el Mac:

```bash
cd /Users/nataliahernandez/prueba
vagrant halt servidorUbuntu clienteUbuntu
```

Los notebooks y modelos se guardan en directorios del anfitrión Ubuntu y sus copias de entrega están en este proyecto. El volumen con nombre `practica_ia_datos` permanece aunque se eliminen los contenedores temporales de la demostración.

## Regenerar el informe y el paquete

Instalar las dependencias de `docs/requirements-informe.txt` en un entorno Python y ejecutar `python scripts/generar-informe.py`. Para producir el ZIP con su manifiesto de integridad, ejecutar `python scripts/empaquetar.py`.
