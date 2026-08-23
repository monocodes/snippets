#!/bin/bash
cd "$(dirname "$0")" || exit
sudo docker compose down --remove-orphans
sudo docker compose build --pull
sudo docker compose up -d --remove-orphans --pull=always
sudo docker image prune -f