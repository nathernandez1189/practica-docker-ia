# Adaptaciones respecto a la guía

## Entorno e imágenes web

Se conservaron Vagrant, VirtualBox, Ubuntu 22.04 y las IP `192.168.100.2` / `192.168.100.3`. En este Mac se reutilizaron las dos máquinas existentes y se arrancaron sin ejecutar su aprovisionamiento anterior.

Se fijó `ubuntu:22.04` en lugar del alias cambiante `ubuntu:latest`. Las instrucciones de instalación de Apache se agruparon en una capa y se limpiaron los índices de paquetes al terminar. Las imágenes personalizadas y de directorios heredan esa base local para ahorrar disco; una imagen publicada contiene todas las capas necesarias y el cliente no necesita construir la base.

En la parte 6, la guía crea `voldocker` pero su Dockerfile intenta copiar `html1`. Se corrige a `COPY voldocker/ /var/www/html/`. Esta parte demuestra una copia durante la construcción; el ejercicio de volúmenes demuestra el montaje durante la ejecución. Son operaciones diferentes.

## Repositorio asashiho/ml-jupyter-python3

Se conserva una copia original y su commit en `evidencias/repositorios.json`. El original pide Python 3.7 y descarga una rueda TensorFlow 1.13.1 para `linux_x86_64`; esa rueda no corresponde al procesador `aarch64` de estas máquinas. Por eso la ejecución preparada usa Python 3.11 y TensorFlow 2.20.0 para ARM64. **No se presenta como una ejecución literal con Python 3.7.**

`ml-jupyter-compatible/Dockerfile.python37-referencia` conserva una variante histórica con las dos correcciones del documento: retirar `libav-tools` y cambiar el paquete `sklearn` por `scikit-learn`; además sustituye las comillas tipográficas inválidas del LABEL. Se incluye para comparar, no como imagen verificada para ARM64.

La variante ejecutable incorpora los tres notebooks originales, con estos ajustes:

- scikit-learn: `load_boston()` se reemplaza por el conjunto incluido `load_diabetes()`; se conserva la regresión y la validación cruzada de 10 particiones.
- TensorFlow: extensión de TensorBoard actualizada; se conservan los registros, se usa un subconjunto MNIST de 2.000/500 imágenes y entrenamiento por lotes durante tres épocas para la memoria disponible. El ejemplo sigue usando la arquitectura Keras del repositorio.
- SciPy: `fig.gca(projection='3d')` se cambia a `fig.add_subplot(111, projection='3d')` para dibujar el mismo sistema de Lorenz con Matplotlib actual.

El contenedor académico incluye las bibliotecas necesarias para esos ejemplos. No se instalaron herramientas ajenas a esos notebooks, como MeCab o las bibliotecas multimedia antiguas.

## Data Science y preprocesamiento

El ejercicio independiente contiene TensorFlow, scikit-learn, NumPy, pandas y Matplotlib. El preprocesamiento se implementa con `sklearn.preprocessing.StandardScaler`; se aprende sobre entrenamiento y luego se aplica a prueba. Se guardan las métricas y el modelo en el directorio compartido.

## Desafío elegido

Se eligió **Docker + Flask**, una de las alternativas indicadas por el profesor. Se ejecuta el código original del repositorio con Python 3.11 y Flask 3.1.2, conservando el puerto 5000 y el servidor de desarrollo de la guía. No se ha realizado el desafío CUDA ni se afirma disponer de una GPU NVIDIA.

## Fuentes consultadas

- [Instalación oficial de Docker en Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Volúmenes en Docker](https://docs.docker.com/engine/storage/volumes/)
- [Bind mounts](https://docs.docker.com/engine/storage/bind-mounts/)
- [Instalación de TensorFlow](https://www.tensorflow.org/install/pip)
- [TensorFlow 2.20.0](https://pypi.org/project/tensorflow/2.20.0/)
- [Repositorio de notebooks](https://github.com/asashiho/ml-jupyter-python3)
- [Repositorio del desafío Flask](https://github.com/omondragon/docker-flask-example)
