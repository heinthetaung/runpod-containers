#!/bin/bash

echo "pod started"

if [[ $PUBLIC_KEY ]]
then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    cd ~/.ssh
    echo $PUBLIC_KEY >> authorized_keys
    chmod 700 -R ~/.ssh
    cd /
    service ssh start
fi

if [[ "$PRIVATE_KEY" ]]
then
    echo "$PRIVATE_KEY" >> ~/.ssh/id_ed25519
    chmod 600 ~/.ssh/id_ed25519
fi

if [[ $RUNPOD_APIKEY ]]
then
    runpodctl config --apiKey=$RUNPOD_APIKEY
fi

if [[ $JUPYTER_PASSWORD ]]
then
    cd /
    jupyter lab --allow-root --no-browser --port=8888 --ip=* --ServerApp.terminado_settings='{"shell_command":["/bin/bash"]}' --ServerApp.token=$JUPYTER_PASSWORD --ServerApp.allow_origin=* --ServerApp.preferred_dir=/workspace
else
    sleep infinity
fi
