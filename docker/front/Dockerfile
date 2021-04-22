FROM node:lts

EXPOSE 3000

WORKDIR /home/node/sites/front

COPY ./entrypoint.sh /usr/local/bin/entrypoint
ENTRYPOINT [ "entrypoint" ]