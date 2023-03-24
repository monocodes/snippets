---
title: dockerfile-examples
categories:
  - software
  - notes
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# dockerfile-examples

- [dockerfile-examples](#dockerfile-examples)
  - [mine](#mine)
    - [port-tool](#port-tool)
  - [devops-project-ud-01](#devops-project-ud-01)
    - [vprofile-multistaged](#vprofile-multistaged)
  - [docker-edu](#docker-edu)
    - [docker-s1](#docker-s1)
    - [docker-s2](#docker-s2)
    - [docker-s3](#docker-s3)
    - [docker-s4](#docker-s4)
    - [docker-s5](#docker-s5)
    - [docker-s6](#docker-s6)
    - [docker-s7](#docker-s7)
    - [docker-s8](#docker-s8)
    - [docker-s9](#docker-s9)

## mine

### port-tool

port-tool `Dockerfile` from [qbt-gluetun](docker-compose-snippets/qbt-gluetun) home setup

```dockerfile
FROM python:3.10-alpine

WORKDIR /app

COPY requirements.txt .

RUN pip install -U pip
RUN pip install -r requirements.txt

COPY . .

ENV QBT_USERNAME=admin
ENV QBT_PASSWORD=adminadmin
ENV QBT_HOST=host.docker.internal
ENV QBT_WEBUI_PORT=8080
ENV GLUETUN_HOST=host.docker.internal
ENV GLUETUN_CTRL_PORT=8000
ENV VERIFY_QBT_WEBUI_CERT='False'

CMD python -u main.py
```

---

## devops-project-ud-01

### vprofile-multistaged

Multistaged `Dockerfile` with cloning specific branch of the repo.

<https://github.com/devopshydclub/vprofile-project/blob/docker/Docker-files/app/multistage/Dockerfile>

`Dockerfile`

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

---

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

    ```text
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

    - ```text
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

    - ```text
            node_modules
            Dockerfile
            .git
            ```

---

### docker-s6

nodejs image with app - `goals-web-nodejs-comp`

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

    - ```text
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

    - ```text
            node_modules
            .git
            Dockerfile
            ```

---

### docker-s7

nodejs image with app - `util-nodejs`

`Dockerfile`

```dockerfile
FROM node:14-alpine

WORKDIR /app

ENTRYPOINT [ "npm" ]
```

---

### docker-s8

`laravel-php-web-docker`

- `composer.dockerfile`

  - ```dockerfile
        FROM composer:latest
        
        RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel
        
        USER laravel 
        
        WORKDIR /var/www/html
        
        ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]
        # --ignore-platform-reqs ensures that we can run
        #this without any warnings or errors even if some
        #dependencies would be missing
        ```

- `nginx.dockerfile`

  - ```dockerfile
        FROM nginx:stable-alpine
         
        WORKDIR /etc/nginx/conf.d
         
        COPY nginx/nginx.conf .
         
        RUN mv nginx.conf default.conf
        
        WORKDIR /var/www/html
         
        COPY src .
        ```

- `php.dockerfile`

  - ```dockerfile
        FROM php:8.1-fpm-alpine
        
        WORKDIR /var/www/html
         
        COPY src .
         
        RUN docker-php-ext-install pdo pdo_mysql
         
        RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel
        
        USER laravel 
         
        # RUN chown -R laravel:laravel .
        ```

---

### docker-s9

nodejs and reactjs images with apps - `goals-web-nodejs-dep`  
deployed to AWS ECS and MongoDB Atlas

- backend

  - `Dockerfile`

    - ```dockerfile
            FROM node:14-alpine
            
            WORKDIR /app
            
            ENTRYPOINT [ "npm" ]
            ```

  - `backend.env`

    - ```text
            MONGODB_USERNAME=
            MONGODB_PASSWORD=
            MONGODB_URL=cluster0.ilhh8s7.mongodb.net
            MONGODB_NAME=goals-dev
            ```

  - `mongo.env`

    - ```text
            MONGO_INITDB_ROOT_USERNAME=
            MONGO_INITDB_ROOT_PASSWORD=
            ```

- frontend prod aws

  - `Dockerfile.prod`

    - ```dockerfile
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

- frontend local

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

---
