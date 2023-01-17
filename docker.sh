# DOCKER INSTALL --------------------------------
# ubuntu
sudo apt update
sudo apt install docker.io

# macos (Docker Desktop)
brew install --cask docker

# add user to docker group to use docker commands without sudo
"""
By default, you’ll have to use sudo command or login to root any time you
want to run a Docker command. This next step is optional, but if you’d prefer
the ability to run Docker as your current user, you can add your account to 
the docker group with this command:
"""
sudo usermod -aG docker $USER
reboot



# DOCKER UNINSTALL ------------------------------
# ubuntu
sudo apt-get remove docker docker-engine docker.io containerd runc docker-ce containerd.io



# DOCKER HELP -----------------------------------
# view help on any command
docker --help
docker ps --help

### DOCKER INSPECT ###
# inspect the image
docker image inspect image-name

# inspect the volume
docker volume inspect volume-name

# inspect the container
docker container inspect container-name



# DOCKER RUN ------------------------------------
# pull image from dockerhub and runs a container based on it

# if image have already been pulled it will use local image version instead
#docker run WILL NOT UPDATE local image, tou need to use docker pull to
#update the local image 

# attached mode is the default

# attached and interactive example
docker run --name rng_app --rm -it rng_py_app:latest

# detached example
docker run --name goalsapp -p 3000:80 --rm -d goals:node12

# Test docker
sudo docker run hello-world

# pull the image and run the container in attached mode
sudo docker run image-name

# pull the image and run the container in detached mode
sudo docker run -d image-name

# run the container and login inside
# -i interactive
# -t tty pseudo terminal to container
sudo docker run -it image-name

# run container on specific port
sudo docker run -p host-port:container-port
# example
docker run -p 3000:80 image-name

# docker run -v maps local host directories to the directories inside the Docker container
docker run -d --name=netdata \
  -p 19999:19999 \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata

# run non-latest container with tag add ':tag' to the name of the container, for example
sudo docker run -d -p 80:80 static-website:beta

# run container with random port - '-P'
sudo docker run -d -P name

# run docker container with specified name
docker run --name container-name image-name
# for example
docker run -p 3000:80 --name goalsapp --rm -d goalsapp:latest

### --rm ### run container and remove it after it will be stopped
docker run --rm image-name



### DOCKER TAG ----------------------------------
# docker tag for renaming images
# creates renamed copy of the image
docker tag image-name:tag account-name/repo-name:tag

# example
docker tag webapp_node:latest  wanderingmono/node-hello-world:latest



# DOCKER CREATE ---------------------------------
# just create container with specified image
# -i interactive
# -t tty pseudo terminal to container
sudo docker create -it --name container-name image-name
sudo docker create -it --name myfirstubuntucontainer ubuntu



# DOCKER START ----------------------------------
# detached mode is the default

# detached example
docker start container-name

# attached and interactive example
docker start -ai container-name

# just start the existing container, container will start in detached mode
sudo docker start container-name

# start the container in attached mode
docker start -a container-name

# start the container in attached mode and log in into it
# -a = --attach - attached mode
# -i = --interactive
sudo docker start -ai container-name



# DOCKER STOP -----------------------------------
# just stop the container
sudo docker stop container-name



# DOCKER ATTACH ---------------------------------
# login to the running container
sudo docker attach container-name



### DOCKER LOGIN & DOCKER LOGOUT ----------------
# login or logout from the dockerhub
docker login
docker logout



### DOCKER PUSH ---------------------------------
# pushes the image to the repo, dockerhub by default or different provider
docker push account-name/repo-name:tag

# example
docker push wanderingmono/node-hello-world:latest



# DOCKER PULL -----------------------------------
# just pull the image with tag latest
docker pull image-name

# pull the image from specific repo
docker pull account-name/repo-name:tag

# example - pull the image from specific repo
docker pull wanderingmono/node-hello-world:latest



# DOCKER SEARCH ---------------------------------
# search a docker image
sudo docker search name



# DOCKER LOGS -----------------------------------
# view the output logs of the container
docker logs container-name

# attach to the running container and view logs in realtime
# can exit with Ctrl+C
docker logs -f container-name



### DOCKER CP -----------------------------------
# cp to copy something inside the running container
# /. - copy everything from the directory
docker cp local/path/. container-name:/container/path

# example
docker cp dummy/. fervent_almeida:/test

# copy from the container to local machine
docker co container-name:/container/path/file.txt local/path
docker cp fervent_almeida:/test/test.txt dummy

# or copy full directory from the container to local machine
docker cp container-name:/container/path local/path
docker cp fervent_almeida:/test dummy



# DOCKER PS -------------------------------------
# see running docker containers
docker ps

# see all containers
docker ps -a
docker container ls -a

# list of all docker images
docker images

# which Docker containers are running and their status
docker container ls

# docker network configuration
docker network ls

# list docker volume
docker volume ls


# DOCKER RM -------------------------------------
# remove the container
sudo docker rm -f container-ID-or-name

# remove docker images
sudo docker rmi -f image-name-or-image-ID

# remove all stopped containers
sudo docker container prune

# remove all unused images
sudo docker image prune

# remove all unused images including tagged ones
docker image prune -a

# remove volume
docker volume rm volume-name

# delete all volumes
docker volume prune



# DOCKER BUILD ----------------------------------
# build image from Dockerfile in current directory example
docker build -t rng_py_app:latest .

# -t to tag the image with name, '.' - use the current directory
docker build -t image-name .
# :name to tag the image with something, for example:
docker build -t static-website:beta .



### DOCKER VOLUME -------------------------------

# create named volume
docker volume create volume-name

# list all volumes
docker volume ls

# inspect the volume
docker volume inspect volume-name

# remove volume
docker volume rm volume-name

# remove all unused volumes
docker volume prune


### Anonymous volumes ###
# create anonymous volume inside the container
# managed by docker, mounted somewhere in host filesystem
# will be removed on container deletion
# effective when you need to lock something inside the container, if it can
#be deleted by another command or module
# Volumes are read-write by default, use ":ro" to make them read-only

# define in Dockerfile
# VOLUME ["/container/path"]
VOLUME ["/app/node_modules"]

# or add in docker run command
# this is the only way to ensure that it will override another bind mount if
#you needed this
# -v /container/path
-v /app/node_modules


### Named volumes ###
# create named volume
# managed by docker, mounted somewhere in host filesystem
# will NOT be removed on container deletion
-v volume-name:/container/path
# example
docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v feedback:/app/feedback wanderingmono/docker-s3:feedback-web-nodejs-v0.3


### Bind mounts ###
# create a bind mount that mounts folder in local system managed by you
# "" used if folder has whitespaces or special symbols
-v "local/path:/container/path"

# example
docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v "/Users/serj/My Drive/study/code/devops/Docker & Kubernetes. The Practical Guide [2023 Edition] [Udemy]/docker-edu/Section 3. Managing Data & Working with Volumes/feedback-web-nodejs/:/app"  wanderingmono/docker-s3:feedback-web-nodejs-v0.3


# to reduce the lenth of the path to the project folder you can use pwd
# macOS / Linux:
-v "$(pwd):/container/path"
-v "$(pwd)/local/path:/container/path"
# Windows:
-v "%cd%":/app

# example
docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v "$(pwd):/app"  wanderingmono/docker-s3:feedback-web-nodejs-v0.3
docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v "$(pwd)/feedback:/app/feedback" -v "$(pwd):/app" -v /app/node_modules wanderingmono/docker-s3:feedback-web-nodejs-v0.3


### Read-only volumes ###
docker run -v local/path:/container/path:ro

# example
docker run -d --rm -p 3000:80 --name feedback-web-nodej
s -v feedback:/app/feedback -v "$(pwd):/app:ro" -v /app/node_modules wanderingmono/docker-s3:feedback-web-nodejs-v0.4

# exclude folders that need to be writable by defining another anonymous or 
#named volume
docker run -d --rm -p 3000:80 --name feedback-web-nodej
s -v feedback:/app/feedback -v "$(pwd):/app:ro" -v /app/temp -v /app/node_modules wanderingmono/docker-s3:feedback-web-nodejs-v0.4


### nodejs setup ###
# typical nodejs setup
# -v "$(pwd):/app" ensures that container
# will use the code from the project path
# -v /app/node_modules ensures that container
# will not overwrite the node_modules directory inside the container

# more info here https://stackoverflow.com/questions/54269442/why-does-docker-create-empty-node-modules-and-how-to-avoid-it/54278208#54278208
# and here https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22166920#questions/13139726

# example
docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v "$(pwd):/app" -v /app/node_modules wanderingmono/docker-s3:feedback-web-nodejs-v0.3



### DOCKER NETWORK ------------------------------
# you don't need to expose ports (-p) of containers which you don't need to
#connect from host machine or internet
# containers can freely communicate with each other through the internal
#docker network
# but you need to expose ports which you do want to connect from the host
# BUT be aware, for example typical React app need exposed ports anyway
#because frontend app connects to the backend app through the local browser,
#not through server because code actually executes in browser, not server

# to address docker to host (localhost, 127.0.0.1) use this address in code
host.docker.internal

# examples
http://host.docker.internal:3000
mongodb://host.docker.internal:27017

### DOCKER NETWORK ###
# create docker network
docker network create network-name

# docker network configuration, view docker networks
docker network ls

# use created network with container and you don't need to publish ports,
#because containers will be using docker network
docker run -d --name container-name --network network-name image-name
# example
docker run -d --name mongodb --network favorites-net mongo
docker run --name favorites-web-nodejs --network favorites-net -d --rm -p 3000:3000 wanderingmono/docker-s4:favorites-web-nodejs-v0.4-mdb-net

# to address your app to another container in the same docker network,
#use container-name in your code
protocol-name://container-name:27017/
# examples
mongodb://mongodb:27017/swfavorites


### NODEJS + REACTJS + MONGODB EXAMPLE ----------
# three containers with docker network

# NOTE if react app don't work properly
#try using interactive mode docker run -it

# database - mongodb
docker run --rm -d \
  --name mongodb \
  -v goals-multi-mongo:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  --network goals-multi-net mongo

# backend - nodejs
docker build -t wanderingmono/docker-s5:goals-be-web-nodejs-v0.3-mdb-dn .

docker run --rm -d -p 80:80 \
  -v "/Users/mono/My Drive/study/code/devops/Docker & Kubernetes. The Practical Guide [2023 Edition] [Udemy]/docker-edu/Section 5. Building Multi-Container Applications with Docker/goals-multi-web-nodejs/backend/logs":/app/logs \
  -v "/Users/mono/My Drive/study/code/devops/Docker & Kubernetes. The Practical Guide [2023 Edition] [Udemy]/docker-edu/Section 5. Building Multi-Container Applications with Docker/goals-multi-web-nodejs/backend":/app \
  -v /app/node_modules \
  -e MONGODB_USERNAME=mongoadmin \
  --name goals-be-web-nodejs \
  --network goals-multi-net \
  wanderingmono/docker-s5:goals-be-web-nodejs-v0.7-mdb-dn-pw-v-nm-env-di

# or
docker run --rm -d -p 80:80 \
  -v "$(pwd)/logs:/app/logs" \
  -v "$(pwd):/app" \
  -v /app/node_modules \
  -e MONGODB_USERNAME=mongoadmin \
  --name goals-be-web-nodejs \
  --network goals-multi-net \
  wanderingmono/docker-s5:goals-be-web-nodejs-v0.7-mdb-dn-pw-v-nm-env-di


# frontend - reactjs
docker build -t wanderingmono/docker-s5:goals-fe-web-react-v0.3-node-local .

docker run --rm -d -p 3000:3000 \
  -v "$(pwd)/src:/app/src" \
  --name goals-fe-web-react \
  wanderingmono/docker-s5:goals-fe-web-react-v0.4-node-local-di



### DOCKERFILE RUNTIME ENV ----------------------
# to use ENV parameters, first, you need to define this ENV parameter in code
# Place ENV variables at the bottom of the file,
#so, the docker will not reexecute unnessesary layers
"""
Environment Variables & Security
One important note about environment variables and security: Depending on which kind of data you're storing in your environment variables, you might not want to include the secure data directly in your Dockerfile.

Instead, go for a separate environment variables file which is then only used at runtime (i.e. when you run your container with docker run).

Otherwise, the values are "baked into the image" and everyone can read these values via docker history <image>.

For some values, this might not matter but for credentials, private keys etc. you definitely want to avoid that!

If you use a separate file, the values are not part of the image since you point at that file when you run docker run. But make sure you don't commit that separate file as part of your source control repository, if you're using source control.
"""

# nodejs code example
app.listen(process.env.PORT);

# second, build a new image with ENV
ENV PORT $port-number
EXPOSE $PORT

# example
ENV PORT 80
EXPOSE $PORT

# third, run the image
docker run -p host-port:container-port --env PORT=port-number
docker run -p host-port:container-port -e PORT=port-number

# example
docker run -d --rm -p 3000:8000 -e PORT=8000 --name feedback-web-nodejs -v feedback:/app/feedback -v "$(pwd):/app" -v /app/node_modules -v /app/temp wanderingmono/docker-s3:feedback-web-nodejs-v0.41-env

# or you can use .env file
docker run -p host-port:container-port --env-file ./filename

# example
docker run -d --rm -p 3000:8000 --env-file ./.env --name feedback-web-nodejs -v feedback:/app/feedback -v "$(pwd):/app" -v /app/node_modules -v /app/temp wanderingmono/docker-s3:feedback-web-nodejs-v0.41-env



### DOCKERFILE BUILD ARG ------------------------
# Place ARG variables at the bottom of the file,
#so, the docker will not reexecute unnessesary layers

# example with PORT ARG
# first, you need to define ENV in Dockerfile and ENV in code of your app ^

# second, you need to define ARG in Dockerfile
ARG arg-name=arg-value

# example
ARG DEFAULT_PORT=80
ENV PORT $DEFAULT_PORT
EXPOSE $PORT

# second, build the image with the arg
docker build -t image-name --build-arg arg-name=arg-value .

# example
docker build -t wanderingmono/docker-s3:feedback-web-nodejs-v0.42-arg-p8000 --build-arg DEFAULT_PORT=8000 .



# DOCKER STATS ----------------------------------
# (monitoring and troubleshooting)
docker stats
# check logs
docker logs container-name

# docker version
docker version
docker info



### DOCKER HISTORY ------------------------------
# view the history of the image
docker history image-name



# script for docker CAdvisor
#!/bin/bash
# Runs Cadvisor Monitoring tool for Docker Containers
VERSION=v0.37.0 # use the latest release version from https://github.com/google/cadvisor/releases
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor:$VERSION



# ANOTHER DOCKER COMMANDS -----------------------

# docker port
# see container ports
docker port container-name



### Docker troubleshooting ----------------------
### DOCKER dataFolder ###
# if you change the profile name and profile dir and docker has old profile dir
"""
I'm not sure if that is everything to fix it, but change the dataFolder in the ~/Library/Group\ Containers/group.com.docker/settings.json file to the new user name and start Docker Desktop again.
"""
~/Library/Group\ Containers/group.com.docker/settings.json


### DOCKER image folder ###
~/Library/Containers/com.docker.docker/Data/vms/0/data/Docker.raw

### DOCKER user folder ###
~/.docker