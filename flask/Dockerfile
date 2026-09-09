FROM python:3.11-slim-bookworm
WORKDIR /app
RUN pip install --no-cache-dir Flask==3.1.2
COPY referencias/docker-flask-example/app/app.py /app/app.py
COPY referencias/docker-flask-example/app/data.py /app/data.py
EXPOSE 5000
CMD ["python", "app.py"]
