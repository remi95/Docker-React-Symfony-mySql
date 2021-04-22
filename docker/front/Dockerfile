FROM node:lts

EXPOSE 3000

ARG WORKDIR_FRONT

WORKDIR ${WORKDIR_FRONT}

COPY ./entrypoint.sh /usr/local/bin/entrypoint
ENTRYPOINT [ "entrypoint" ]