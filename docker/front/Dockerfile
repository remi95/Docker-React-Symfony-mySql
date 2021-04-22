FROM node:lts

EXPOSE 3000

WORKDIR /var/www/front

COPY ./entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT [ "entrypoint" ]