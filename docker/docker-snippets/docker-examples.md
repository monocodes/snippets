---
title: docker-examples
categories:
  - software
  - CI/CD
  - examples
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [docker-edu](#docker-edu)
  - [docker-s1](#docker-s1)
  - [docker-s2](#docker-s2)
  - [docker-s3](#docker-s3)
  - [docker-s4](#docker-s4)
  - [docker-s5](#docker-s5)
  - [docker-s6-goals-web-nodejs-comp-docker-compose.yaml](#docker-s6-goals-web-nodejs-comp-docker-composeyaml)
  - [docker-s7-util-nodejs-docker-compose.yaml](#docker-s7-util-nodejs-docker-composeyaml)
  - [docker-s8-laravel-php-web-docker-compose.yaml](#docker-s8-laravel-php-web-docker-composeyaml)
  - [docker-s9-goals-web-nodejs-docker-compose.yaml](#docker-s9-goals-web-nodejs-docker-composeyaml)
  - [docker-s9-goals-web-nodejs-test-docker-compose.yaml](#docker-s9-goals-web-nodejs-test-docker-composeyaml)
- [devops-project-ud-01](#devops-project-ud-01)
  - [Section 20 - Docker](#section-20---docker)
    - [vprofile-project](#vprofile-project)
    - [emartapp](#emartapp)

## docker-edu

### docker-s1

nodejs image with app - `first-demo-docker`

`Dockerfile`

```dockerfile
FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "node", "app.mjs" ]
```

---

### docker-s2

python image with app - `bmi-app-py`

`Dockerfile`

```dockerfile
FROM python

WORKDIR /app

COPY . /app

CMD ["python", "bmi.py"]
```

nodejs image with app - `hello-world-web-nodejs`

`Dockerfile`

```dockerfile
FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
```

nodejs image with app - `goals-web-nodejs`

`Dockerfile`

```dockerfile
FROM node

WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app

EXPOSE 80

CMD ["node", "server.js"]
```

python image with app - `rng-app-py`

`Dockerfile`

```dockerfile
FROM python

WORKDIR /app

COPY . /app

CMD ["python", "rng.py"]
```

---

### docker-s3

nodejs image with app - `feedback-web-nodejs`

- `Dockerfile`  

  ```dockerfile
  FROM node:14
  
  WORKDIR /app
  
  COPY package.json .
  
  RUN npm install
  
  COPY . .
  
  ARG DEFAULT_PORT=80
  
  ENV PORT $DEFAULT_PORT
  
  EXPOSE $PORT
  
  # VOLUME ["/app/node_modules"]
  
  # VOLUME ["/app/temp"]
  
  CMD ["npm", "start"]
  ```

- `.dockerignore`  

  ```properties
  nodejs
  node_modules/
  
  git
  .git/
  
  Dockerfiles
  Dockerfile
  ```

---

### docker-s4

nodejs image with app - `favorites-web-nodejs`

`Dockerfile`

```dockerfile
FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

CMD ["node", "app.js"]
```

---

### docker-s5

nodejs image with app - `goals-multi-web-nodejs`

- backend

  - `Dockerfile`

    - ```dockerfile
          FROM node
          
          WORKDIR /app
          
          COPY package.json .
          
          RUN npm install
          
          COPY . .
          
          EXPOSE 80
          
          ENV MONGODB_USERNAME=root
          ENV MONGODB_PASSWORD=secret
          
          CMD ["npm", "start"]
      ```

  - `.dockerignore`

    - ```properties
          node_modules
          Dockerfile
          .git
      ```

- frontend

  - `Dockerfile`

    - ```dockerfile
          FROM node
          
          WORKDIR /app
          
          COPY package.json .
          
          RUN npm install
          
          COPY . .
          
          EXPOSE 3000
          
          CMD [ "npm", "start" ]
      ```

  - `.dockerignore`

    - ```properties
          node_modules
          Dockerfile
          .git
      ```

---

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

`backend/Dockerfile` + `backend/.dockerignore`

```dockerfile
FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

ENV MONGODB_USERNAME=root
ENV MONGODB_PASSWORD=secret

CMD ["npm", "start"]
```

```properties
node_modules
Dockerfile
.git
```

`frontend/Dockerfile` + `frontend/.dockerignore`

```dockerfile
FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]
```

```properties
node_modules
.git
Dockerfile
```

---

### docker-s7-util-nodejs-docker-compose.yaml

nodejs image with app - docker-s7  
util-nodejs

`docker-compose.yaml`

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

`Dockerfile`

```dockerfile
FROM node:14-alpine

WORKDIR /app

ENTRYPOINT [ "npm" ]
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

`composer.dockerfile`

```dockerfile
FROM composer:latest

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

USER laravel 

WORKDIR /var/www/html

ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]
# --ignore-platform-reqs ensures that we can run
#this without any warnings or errors even if some
#dependencies would be missing
```

`nginx.dockerfile`

```dockerfile
FROM nginx:stable-alpine

WORKDIR /etc/nginx/conf.d

COPY nginx/nginx.conf .

RUN mv nginx.conf default.conf

WORKDIR /var/www/html

COPY src .
```

`php.dockerfile`

```dockerfile
FROM php:8.1-fpm-alpine

WORKDIR /var/www/html

COPY src .

RUN docker-php-ext-install pdo pdo_mysql

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

USER laravel 

# RUN chown -R laravel:laravel .
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

`backend/Dockerfile` + `backend.env` + `mongo.env`

```dockerfile
FROM node:14-alpine

WORKDIR /app

ENTRYPOINT [ "npm" ]
```

`backend.env`

```properties
MONGODB_USERNAME=
MONGODB_PASSWORD=
MONGODB_URL=cluster0.ilhh8s7.mongodb.net
MONGODB_NAME=goals-dev
```

`mongo.env`

```properties
MONGO_INITDB_ROOT_USERNAME=
MONGO_INITDB_ROOT_PASSWORD=
```

**frontend prod aws**  
`frontend/Dockerfile.prod`

```dockerfile
FROM node:14-alpine as build

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

FROM nginx:stable-alpine

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

**frontend local**  
`frontend/Dockerfile`

```dockerfile
FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]
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

## devops-project-ud-01

### Section 20 - Docker

#### vprofile-project

> There are problems with this project. Imran messed up with db or app, so app couldn't connect to db with self-builded images.
>
> It is possible to run the project normally only with Imran's images.
>
> **So, I tagged his images with my names and pushed them to my repos.**

my `docker-compose.yaml`

```yaml
version: "3.8"
services:
  vproweb:
    image: wanderingmono/vprofileweb:V1
    ports:
      - "80:80"

  vproapp:
    image: vprofile/vprofileapp:V1
    ports:
      - "8080:8080"

  vprocache01:
    image: memcached
    ports:
      - "11211:11211"

  vpromq01:
    image: rabbitmq
    ports:
      - "15672:15672"
    environment:
      - RABBITMQ_DEFAULT_USER=guest
      - RABBITMQ_DEFAULT_PASS=guest

  vprodb:
    image: wanderingmono/vprofiledb:V1
    ports:
      - "3306:3306"
    volumes:
      - vprodbdata:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=vprodbpass

volumes:
  vprodbdata: {} # don't know why {} here
```

Imran's `docker-compose.yaml` with **fixed** images that I also used.

```yaml
version: '3'
services:
  vpronginx:
    image: visualpath/vpronginx
    ports:
      - "80:80"

  vproapp:
    image: imranvisualpath/vproappfix
    ports:
      - "8080:8080"

  vprocache01:
    image: memcached
    ports:
      - "11211:11211"

  vpromq01:
    image: rabbitmq
    ports:
      - "15672:15672"
    environment:
      - RABBITMQ_DEFAULT_USER=guest
      - RABBITMQ_DEFAULT_PASS=guest

  vprodb:
    image: imranvisualpath/vprdbfix
    ports:
      - "3306:3306"
    volumes:
      - vprodbdata:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=vprodbpass

volumes:
  vprodbdata: {}
```

`app/Dockerfile`

```dockerfile
FROM tomcat:8-jre11

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
```

`app/multistage/Dockerfile`  
`Dockerfile` with build stage

```dockerfile
FROM openjdk:8 AS BUILD_IMAGE
RUN apt update && apt install maven -y
RUN git clone -b vp-docker https://github.com/imranvisualpath/vprofile-repo.git
RUN cd vprofile-repo && mvn install

FROM tomcat:8-jre11

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=BUILD_IMAGE vprofile-repo/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
```

`db/Dockerfile`

```dockerfile
FROM mysql:5.7.25

ENV MYSQL_ROOT_PASSWORD="vpropass"
ENV MYSQL_DATABASE="accounts"

ADD db_backup.sql docker-entrypoint-initdb.d/db_backup.sql
```

`web/Dockerfile`

```dockerfile
FROM nginx
LABEL "Project"="Vprofile"
LABEL "Author"="Imran"

RUN rm -rf /etc/nginx/conf.d/default.conf
COPY nginvproapp.conf /etc/nginx/conf.d/vproapp.conf
```

`web/nginvproapp.conf`  
it's **nginx** config

```nginx
upstream vproapp {
  server vproapp:8080;
}
server {
  listen 80;
location / {
  proxy_pass http://vproapp;
}
}
```

---

#### emartapp

```yaml
version: "3.8"
services:
    client:
        build:
            context: ./client
        ports:
            - "4200:4200"
        container_name: client
        depends_on:
            [api, webapi]

    api:
        build:
            context: ./nodeapi
        ports:
            - "5000:5000"
        container_name: api
        # depends_on:
        #    - nginx
        #    - emongo
        depends_on:
            [emongo]

    webapi:
        build:
            context: ./javaapi
        ports:
            - "9000:9000"
        restart: always
        container_name: webapi
        depends_on:
            [emartdb]

    nginx:
        restart: always
        image: nginx:latest
        container_name: nginx
        volumes:
            - "./nginx/default.conf:/etc/nginx/conf.d/default.conf"
        ports:
            - "80:80"
        command: ['nginx-debug', '-g', 'daemon off;']
        depends_on:
            [client]

    emongo:
       image: mongo:4
       container_name: emongo
       environment:
         - MONGO_INITDB_DATABASE=epoc
       ports:
         - "27017:27017"
    emartdb:
      image: mysql:5.7
      container_name: emartdb
      ports:
         - "3306:3306"
      environment:
        - MYSQL_ROOT_PASSWORD=emartdbpass     
        - MYSQL_DATABASE=books
```

`client/Dockerfile`

```dockerfile
FROM node:14 AS web-build
WORKDIR /usr/src/app
COPY ./ ./client
RUN cd client && npm install && npm run build --prod

# Use official nginx image as the base image
FROM nginx:latest

# Copy the build output to replace the default nginx contents.
COPY --from=web-build /usr/src/app/client/dist/client/ /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 4200
EXPOSE 4200
```

`javaapi/Dockerfile`

```dockerfile
FROM openjdk:8 AS BUILD_IMAGE
WORKDIR /usr/src/app/
RUN apt update && apt install maven -y
COPY ./ /usr/src/app/
RUN mvn install -DskipTests

FROM openjdk:8

WORKDIR /usr/src/app/
COPY --from=BUILD_IMAGE /usr/src/app/target/book-work-0.0.1-SNAPSHOT.jar ./book-work-0.0.1.jar

EXPOSE 9000
ENTRYPOINT ["java","-jar","book-work-0.0.1.jar"]
```

`nginx/default.conf`

```nginx
#upstream api {
#    server api:5000; 
#}
#upstream webapi {
#    server webapi:9000;
#}
upstream client {
    server client:4200;
}
server {
    listen 80;
    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme; 

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_pass http://client/;
    }
    location /api {
#        rewrite ^/api/(.*) /$1 break; # works for both /api and /api/
#        proxy_set_header Host $host;
#        proxy_set_header X-Real-IP $remote_addr;
#        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#        proxy_set_header X-Forwarded-Proto $scheme; 
#        proxy_http_version 1.1;

        proxy_pass http://api:5000;
    }
    location /webapi {
#        rewrite ^/webapi/(.*) /$1 break;
#        proxy_set_header Host $host;
#        proxy_set_header X-Real-IP $remote_addr;
##        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass http://webapi:9000;
    }
}
```

`nodeapi/Dockerfile`

```dockerfile
FROM node:14 AS nodeapi-build
WORKDIR /usr/src/app
COPY ./ ./nodeapi/
RUN cd nodeapi && npm install

FROM node:14
WORKDIR /usr/src/app/
COPY --from=nodeapi-build /usr/src/app/nodeapi/ ./
RUN ls
EXPOSE 5000
CMD ["/bin/sh", "-c", "cd /usr/src/app/ && npm start"]
```

---
