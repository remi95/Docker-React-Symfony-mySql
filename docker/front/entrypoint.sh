#!/bin/bash

# React project already created
if [ -f "package.json" ]; then
    npm install;
else
    # Init project
    if [ $USE_TYPESCRIPT = 1 ]; then
        npx create-react-app . --template typescript;
    else
        npx create-react-app .
    fi
fi

chown -R node:node .;

su - node -c "cd $WORKDIR_FRONT && npm run start";