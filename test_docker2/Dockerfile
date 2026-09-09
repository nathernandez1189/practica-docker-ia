FROM practica/ubuntuweb:base
# La guía crea voldocker, pero dice COPY html1: se corrige ese nombre.
COPY voldocker/ /var/www/html/
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
