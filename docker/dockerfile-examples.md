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

```dockerfile
FROM python

WORKDIR /app

COPY . /app

CMD ["python", "bmi.py"]
```

nodejs image with app - `hello-world-web-nodejs`

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

```dockerfile
FROM python

WORKDIR /app

COPY . /app

CMD ["python", "rng.py"]
```

---

### docker-s3

nodejs image with app - `feedback-web-nodejs`

- `.dockerignore` file  

    ```text
    nodejs
    node_modules/
    
    git
    .git/
    
    Dockerfiles
    Dockerfile
    ```

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

---

### docker-s4
