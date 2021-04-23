#!/bin/bash

# =========
# Utilities
# =========

lightGreen="\033[1;32m";
violinIcon="\xf0\x9f\x8e\xbb"

function log () {
    echo -e "${violinIcon} ${lightGreen}$1";
}

# =================
# Commands executed
# =================

if [ -f "composer.json" ]; then
    log "Running composer install...";
    composer install;
    
    log "Updating database with migrations...";
    bin/console doctrine:migrations:migrate -n --allow-no-migration;
    bin/console cache:clear;
else
    log "Initializing new Symfony project...";
    symfony new . --full --no-git;
    cp .env .env.local;
    sed -i '/^#/d' .env.local; # Remove all comments
    sed -i "s|DATABASE_URL=.*|DATABASE_URL=\"mysql://$MYSQL_USER:$MYSQL_PASSWORD@docker_mysql:3306/$MYSQL_DATABASE?serverVersion=5.7\"|i" .env.local;
    bin/console doctrine:database:create -n --if-not-exists;
    bin/console cache:clear;
fi

chown -R www-data:www-data .;

log "Symfony project ready ! Let's coding !";
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf;
