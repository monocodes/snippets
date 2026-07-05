#!/bin/bash
sudo docker compose down --remove-orphans
sudo docker compose build --pull # to rebuild Dockerfile images
sudo docker compose up -d --remove-orphans --pull=always
sudo docker image prune -af