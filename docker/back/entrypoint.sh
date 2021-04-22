#!/bin/bash

# Symfony already created
if [ -f "composer.json" ]; then
    composer install;
    bin/console doctrine:migrations:migrate -n --allow-no-migration;
    bin/console cache:clear;
else
    # Init project
    symfony new . --full --no-git;
    sed -i "s|#!/usr/bin/env php|#!/usr/bin/env php8|i" bin/console;
    cp .env .env.local;
    sed '/^#/d' .env.local; # Remove all comments
    sed -i "s|DATABASE_URL=*|DATABASE_URL=\"mysql://$MYSQL_USER:$MYSQL_PASSWORD@docker_mysql:3306/$MYSQL_DATABASE?serverVersion=5.7\"|i" .env.local;
    bin/console doctrine:database:create -n --if-not-exists;
    bin/console cache:clear;
fi

chown -R www-data:www-data .

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf;
