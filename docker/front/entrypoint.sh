#!/bin/bash

# =========
# Utilities
# =========

lightBlue="\033[1;34m";
atomIcon="\xe2\x9a\x9b\xef\xb8\x8f";

function log () {
    echo -e "${atomIcon}  ${lightBlue}$1";
}

# =================
# Commands executed
# =================

if [ -f "package.json" ]; then
    log "Running npm install...";
    npm install;
else
    rm ./*; # React need an empty directory to init project.
    
    log "Initializing new React project...";
    if [ $USE_TYPESCRIPT = 1 ]; then
        npx create-react-app . --template typescript;
    else
        npx create-react-app .
    fi
fi

chown -R node:node .;

log "Starting your React project... Let's coding !";
su - node -c "cd $WORKDIR_FRONT && npm run start";
