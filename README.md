# Docker for React / Symfony / mySQL

- [Docker for React / Symfony / mySQL](#docker-for-react--symfony--mysql)
  - [Requirements](#requirements)
  - [Usage](#usage)
  - [Configuration](#configuration)
  - [Connect to containers](#connect-to-containers)
  - [Details](#details)
    - [Nginx/PHP container](#nginxphp-container)
      - [Image and configuration](#image-and-configuration)
      - [Entrypoint](#entrypoint)
      - [Informations](#informations)
    - [NodeJS container](#nodejs-container)
    - [Image](#image)
    - [Entrypoint](#entrypoint-1)
    - [Informations](#informations-1)
    - [MySQL container](#mysql-container)
      - [Image](#image-1)
      - [Informations](#informations-2)
  - [Context](#context)

Docker environment to automatically initialize both **React** & **Symfony** projects, running with **Nginx** and **MySQL**.

## Requirements
- [Docker](https://docs.docker.com/engine/install/) 
- [Docker-compose](https://docs.docker.com/compose/install/)

## Usage

```bash
https://github.com/remi95/Docker-React-Symfony-mySql.git myProject

cd myProject
docker-composer up --build
```

Add `127.0.0.1 local.admin.fr` into your `/etc/hosts` file.

That's it !

Access Symfony at http://local.admin.fr and React at http://localhost:3000

To customize some parameters, see [configuration](#configuration).

## Configuration

All the configuration is in the `.env` file.   
The most important for you is the _Project configuration_ part :

| ENV variable        | Description                                                                               |
| ------------------- | ----------------------------------------------------------------------------------------- |
| DIRECTORY_BACK      | The directory name for your **Symfony** project on your host.                             |
| DIRECTORY_FRONT     | The directory name for your **React** project on your host.                               |
| BACKEND_URL         | The **URL** to use for your backend. Don't forget to add this in your `/etc/hosts` file ! |
| USE_TYPESCRIPT      | **1** if yout want to use React with typescript, else **0**.                              |
| MYSQL_ROOT_PASSWORD | The mySQL _root_ password                                                                 |
| MYSQL_DATABASE      | The name of your database used by Symfony.                                                |
| MYSQL_USER          | Your mySQL user name.                                                                     |
| MYSQL_PASSWORD      | Your mySQL user's password.                                                               |


## Connect to containers

All containers are named, so you can easily connect to them.

```bash
# Nginx container
docker exec -itu www-data docker_nginx bash

# NodeJS container
docker exec -itu node docker_react bash

# MySQL container
docker exec -it docker_mysql bash
```

## Details

There are 3 containers, [configurable](#configuration) with environment variables.

### Nginx/PHP container

#### Image and configuration

This container is based on [Alpine](https://hub.docker.com/_/alpine) image.  
**Nginx** and **PHP8** are both installed and configured manually. 

If you want to customize the **vhost**, edit the `docker/back/nginx/admin.conf` file.   
Be careful, *server_name* and *root* are override on `docker/back/Dockerfile` with environment variables. 

**Composer** and **Symfony CLI** are also installed to easily interact with your Symfony project.

#### Entrypoint 

When the container start, the `docker/back/entrypoint.sh` file is executed.   
The first time, it will *install* your Symfony project.   
The other times, it will run `composer install` & `doctrine:migrations:migrate`.

You can edit this file, if you don't want to run composer each time for example. 

**Important** : After any edition of configuration file, don't forget to run `docker-compose up --build`.

#### Informations

Your Symfony project is running on http://local.admin.fr:80, or at the *BACKEND_URL* you defined in the `.env` file.

If you connect to the *docker_nginx* container, you can use the **www-data** user.


### NodeJS container

### Image

This container is based on [Node](https://hub.docker.com/_/node) LTS image. 

### Entrypoint

When the container start, the `docker/front/entrypoint.sh` file is executed.   
The first time, it will **install** your React project with or without Typescript, depending on your configuration in `.env` file.   
The other times, it will run `npm install`.   
Every time, it automatically run `npm start`.

You can edit this file, if you don't want to run npm install each time for example. 

**Important** : After any edition of configuration file, don't forget to run `docker-compose up --build`.

### Informations 

Your React project is running on http://localhost:3000.

If you connect to the *docker_react* container, you can use the **node** user.


### MySQL container

#### Image

This container is based on [MySQL](https://hub.docker.com/_/mysql) latest image. 

#### Informations

You can connect to your database with your favorite MySQL client by using informations in the `.env` file and port **3306**.

## Context

Made by **Rémi Mafat** during a Master 2 course on Docker.