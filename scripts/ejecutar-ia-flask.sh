#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
exec > >(tee evidencias/ejercicios-ia-flask.log) 2>&1
set -x
docker build -t practica/data-science:local ./data-science
docker run -d --name jupyter-ia -p 192.168.100.3:8888:8888 \
  --mount "type=bind,source=$PWD/data-science/notebooks,target=/notebooks" practica/data-science:local
docker exec jupyter-ia jupyter nbconvert --to notebook --execute \
  --ExecutePreprocessor.timeout=600 --output 01-iris-docker-ia-ejecutado.ipynb /notebooks/01-iris-docker-ia.ipynb
docker exec jupyter-ia cat /notebooks/resultados/metricas.json
docker build -t practica/ml-jupyter:arm64 ./ml-jupyter-compatible
docker run -d --name ml-jupyter -p 192.168.100.3:8890:8888 \
  --mount "type=bind,source=$PWD/ml-jupyter-compatible/notebooks,target=/notebooks" practica/ml-jupyter:arm64
for notebook in 1.scikit-learnSample 2.TensorFlowSample 3.ScipySample; do
  docker exec ml-jupyter jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 \
    --output "$notebook-ejecutado.ipynb" "/notebooks/$notebook.ipynb"
done
docker build -t practica/flask:v1 -f flask/Dockerfile .
docker run -d --name flask-practica -p 192.168.100.3:5000:5000 practica/flask:v1
sleep 3
curl --fail http://192.168.100.3:5000
docker logs flask-practica
docker ps
