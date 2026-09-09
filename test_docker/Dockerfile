FROM ubuntu:22.04
RUN apt-get update && apt-get install -y --no-install-recommends apache2 apache2-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY html1/ /var/www/html/
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
