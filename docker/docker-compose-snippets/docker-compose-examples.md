---
title: docker-compose-examples
categories:
  - software
  - CI/CD
  - examples
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# docker-compose-examples

- [docker-compose-examples](#docker-compose-examples)
  - [docker-udemy](#docker-udemy)
    - [docker-s6-goals-web-nodejs-comp-docker-compose.yaml](#docker-s6-goals-web-nodejs-comp-docker-composeyaml)
    - [docker-s7-util-nodejs-docker-compose.yaml](#docker-s7-util-nodejs-docker-composeyaml)
    - [docker-s8-laravel-php-web-docker-compose.yaml](#docker-s8-laravel-php-web-docker-composeyaml)
    - [docker-s9-goals-web-nodejs-docker-compose.yaml](#docker-s9-goals-web-nodejs-docker-composeyaml)
    - [docker-s9-goals-web-nodejs-test-docker-compose.yaml](#docker-s9-goals-web-nodejs-test-docker-composeyaml)

## docker-udemy

### docker-s6-goals-web-nodejs-comp-docker-compose.yaml

nodejs image with app - docker-s6  
goals-web-nodejs-comp

```yaml
version: '3.8'
services:
  mongodb:
    image: 'mongo'
    volumes:
      - data:/data/db # named volume, need to be
      # in the end of docker file
    
    # define a name of the container
    # container_name: mongodb

    environment:
      - MONGO_INITDB_ROOT_USERNAME=max
      - MONGO_INITDB_ROOT_PASSWORD=secret
      
      # could use this form
      # MONGO_INITDB_ROOT_USERNAME: max
    
    # you could specify .env file with envs here 
    # env_file:
    #  - ./env/mongo.env

    # you could specify networks here
    # networks:
    #  - goals-net

  backend:
    build: ./backend
    ports:
      - '80:80'
    volumes:
      - logs:/app/logs # named volume
      - ./backend:/app # bind mount,relative path
      - /app/node_modules # unnamed volume
    env_file:
      - ./env/backend.env
    depends_on:
      - mongodb

    # you can give a name to the image and then
    # proceed with the build:
    image: wanderingmono/docker-s6:goals-web-nodejs-backend-comp-v0.1
    
    # if Dockerfile has been renamed or in the
    # different dir, or you want to use args,
    # you can use context: and agrs: be sure
    # that Dockerfile have all things it needs
    # in the same dir
    # build:
    #   context: ./backend
    #   dockerfile: Dockerfile-dev
    #   args:
    #     some-agr: 1

  frontend:
    build: ./frontend
    ports:
      - '3000:3000'
    volumes:
      - ./frontend/src:/app/src
    depends_on:
      - backend
    image: wanderingmono/docker-s6:goals-web-nodejs-frontend-comp-v0.1

    # -it in docker compose:
    # stdin_open: true
    # tty: true
    

volumes:
  data: # named volume
  logs: # named volume
```

---

### docker-s7-util-nodejs-docker-compose.yaml

nodejs image with app - docker-s7  
util-nodejs

```yaml
version: "3.8"
services:
  npm:
    build: ./
    stdin_open: true
    tty: true
    volumes:
      - ./:/app
```

---

### docker-s8-laravel-php-web-docker-compose.yaml

```yaml
version: "3.8"

services:
  server:
    # image: nginx:stable-alpine
    build:
      context: .
      dockerfile: dockerfiles/nginx.dockerfile
    image: wanderingmono/docker-s8:laravel-php-web-nginx-v0.2-fixed-dpl
    ports:
      - '8000:80'
    volumes:
      - ./src:/var/www/html
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - php
      - mysql

  php:
    build:
      context: .
      dockerfile: dockerfiles/php.dockerfile
    image: wanderingmono/docker-s8:laravel-php-web-php-v0.2-fixed-dpl
    volumes:
      - ./src:/var/www/html:delegated
      # :delegated - is the optimization
      #if the container needs to write some data
      #to the folder back to the host machine
      #it will precces it in batches for better
      #performance
    # ports:
    #   - '3000:9000'

  mysql:
    platform: linux/x86_64
    image: mysql
    env_file:
      - ./env/mysql.env

  composer:
    build:
      context: ./dockerfiles
      dockerfile: composer.dockerfile
    image: wanderingmono/docker-s8:laravel-php-web-composer-v0.2-fixed-dpl
    volumes:
      - ./src:/var/www/html
  
  artisan:
    build:
      context: .
      dockerfile: dockerfiles/php.dockerfile
    image: wanderingmono/docker-s8:laravel-php-web-artisan-v0.2-fixed-dpl
    volumes:
      - ./src:/var/www/html
    entrypoint: ["php", "/var/www/html/artisan"]
    # entrypoint disables RUN command in
    # dockerfile and executes itself command

  npm:
    image: node:14
    working_dir: /var/www/html
    entrypoint: ["npm"]
    volumes:
      - ./src:/var/www/html
```

---

### docker-s9-goals-web-nodejs-docker-compose.yaml

```yaml
version: '3.8'
services:
  backend:
    build: ./backend
    ports:
      - '80:80'
    volumes:
      - ./backend:/app
      - /app/node_modules
    env_file:
      - ./env/backend.env
  frontend:
    build: ./frontend
    ports:
      - '3000:3000'
    volumes:
      - ./frontend/src:/app/src
    stdin_open: true
    tty: true
    depends_on:
      - backend
```

---

### docker-s9-goals-web-nodejs-test-docker-compose.yaml

```yaml
version: '3.8'
services:
  # mongodb:
  #   image: 'mongo'
  #   volumes:
  #     - data:/data/db
  #   env_file:
  #     - ./env/mongo.env
  backend:
    image: wanderingmono/docker-s9:goals-web-nodejs-dep-v0.1-arm64
    build: ./backend
    ports:
      - '80:80'
    volumes:
      - ./backend:/app
      - /app/node_modules
    env_file:
      - ./env/backend.env
    # depends_on:
    #   - mongodb

# volumes:
#   data:
```

---
