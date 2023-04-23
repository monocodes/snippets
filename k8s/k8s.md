---
title: k8s
categories:
  - software
  - CI/CD
  - notes
  - guides
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# k8s

- [k8s](#k8s)
  - [k8s install](#k8s-install)
    - [Linux](#linux)
      - [Linux paths](#linux-paths)
    - [linuxbrew](#linuxbrew)
      - [Ubuntu 22](#ubuntu-22)
      - [Ubuntu \<22, Debian \<12](#ubuntu-22-debian-12)
      - [Red Hat-based distros (CentOS, Fedora, RHEL, Rocky)](#red-hat-based-distros-centos-fedora-rhel-rocky)
      - [kubectl shell autocompletion](#kubectl-shell-autocompletion)
    - [macOS](#macos)
      - [k8s paths macos](#k8s-paths-macos)
    - [minikube](#minikube)
      - [minikube install macos](#minikube-install-macos)
        - [change minikube resources](#change-minikube-resources)
      - [minikube service](#minikube-service)
  - [k8s commands](#k8s-commands)
    - [get](#get)
    - [apply](#apply)
    - [delete](#delete)
    - [create](#create)
    - [expose](#expose)
    - [set](#set)
    - [rollout](#rollout)
    - [scale](#scale)

## k8s install

### Linux

#### Linux paths

kubectl configuration

```sh
~/.kube/config
```

kubectl version

```sh
kubectl version --output=yaml

kubectl version --short
```

---

### linuxbrew

one-liner install linuxbrew

```sh
brew update && brew install kubectl
```

#### Ubuntu 22

one-liner install Ubuntu 22 from [Install and Set Up kubectl on Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

```sh
sudo apt-get update && \
  sudo apt-get install -y ca-certificates curl && \
  sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update && \
  sudo apt-get install -y kubectl && \
  sudo apt install -y bash-completion && \
	echo 'source <(kubectl completion bash)' >>~/.bashrc && \
	source ~/.bashrc
```

#### Ubuntu <22, Debian <12

one-liner install from [Install and Set Up kubectl on Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

If you use Debian 9 (stretch) or earlier you would also need to install `apt-transport-https` with `sudo apt-get install -y apt-transport-https`

```sh
sudo apt-get update && \
  sudo apt-get install -y ca-certificates curl && \
  sudo mkdir /etc/apt/keyrings/ && \
  sudo chmod 755 /etc/apt/keyrings/ && \
  sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update && \
  sudo apt-get install -y kubectl && \
	echo 'source <(kubectl completion bash)' >>~/.bashrc && \
	source ~/.bashrc
```

#### Red Hat-based distros (CentOS, Fedora, RHEL, Rocky)

one-liner install from [Install and Set Up kubectl on Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

```sh
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo dnf install -y kubectl && \
	echo 'source <(kubectl completion bash)' >>~/.bashrc && \
	source ~/.bashrc
```

#### kubectl shell autocompletion

[Enable shell autocompletion](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#enable-shell-autocompletion)

one-liner for **Ubuntu**

```sh
sudo apt install -y bash-completion && \
	kubectl completion bash && \
	echo 'source <(kubectl completion bash)' >>~/.bashrc && \
	source ~/.bashrc
```

1. Install `bash-completion`

   ```sh
   apt-get install bash-completion
   # or
   yum install bash-completion
   ```

2. Generate kubectl completion script

   ```sh
   kubectl completion bash
   ```

3. Enable kubectl autocompletion for bash for user

   ```sh
   echo 'source <(kubectl completion bash)' >>~/.bashrc
   ```

### macOS

install kubectl

```sh
brew install kubectl
```

check installed kubectl

```sh
kubectl version --client
```

---

#### k8s paths macos

`kubectl` config path

```sh
~/.kube/config

# or
kubectl config view
```

---

### minikube

#### minikube install macos

minikube - local virtualized k8s cluster.

```sh
brew install minikube
```

>if docker desktop installed you could use docker to create VM for k8s cluster

start minikube with normal resources

```sh
minikube start --memory 4096 --cpus 4
```

start minikube with docker driver with default resources (2 cpus, 2GB)

```sh
minikube start
```

check minkube status

```sh
minikube status
```

start minikube web dashboard

```sh
minikube dashboard
```

---

##### change minikube resources

give more resources to minikube *with deletion* of the cluster

```sh
minikube stop
minikube delete
minikube start --memory 4096 --cpus 4
```

give more resources to minikube *without deletion* of the cluster  
won't work with every driver (**won't work with docker driver**)

```sh
minikube stop
minikube config set memory 4096
minikube config set cpus 4
minikube start
```

---

#### minikube service

show minikube service list

```sh
minikube service list
```

create service to expose app in k8s cluster to local machine

```sh
minikube service deployment-name

# example
minikube service first-app
```

---

## k8s commands

show k8s config

```sh
kubectl config view
```

---

### get

show all nodes

```sh
kubectl get nodes
```

show all deployments and its status

```sh
kubectl get deployments
```

show all pods created by deployments

```sh
kubectl get pods
```

show all services

```sh
kubectl get service
```

---

### apply

start the deployment from `*.yaml` file

> use multiple `-f` in command to deploy something, or use comma  
> `-f` = file

```sh
kubectl apply -f=deployment-name.yaml,deployment-name2.yaml

# example
kubectl apply -f=deployment.yaml
```

>Can change anything in deployment just changing the `*.yaml` files and apply them again. For example, change number of replicas or image.

---

### delete

delete service

```sh
kubectl delete service service-name
```

delete deployment

```sh
kuvectl delete deployment deployment-name

kubectl delete deployments.apps deployment-name
```

delete multiple deployments that was applied with `kubectl apply -f`

```sh
kubectl delete -f=deployment-name.yaml

# example
kubectl delete -f=deployment.yaml,service.yaml
```

delete multiple objects using labels

> objects need to be labeled  
> in command you must include object types (e. g. deployments, services)  
> `-l` = label

```sh
kubectl delete deployments,services -l key=value

# example
kubectl delete deployments,services -l group=example 
```

---

### create

create new deployment

```sh
kubectl create deployment deployment-name --image=image-name

# example
kubectl create deployment first-app --image=account-name/repo-name:app-web-nodejs-kub
```

to create multiple containers based on images separate images with comma

```sh
kubectl create deployment deployment-name --image=image-name,image-name2
```

---

### expose

expose port of the running deployment with load balancer  
actually it creates a service object

```sh
kubectl expose deployment deployment-name --type=LoadBalancer --port=port-number

# example
kubectl expose deployment first-app --type=LoadBalancer --port=8080
```

---

### set

`set` to update deployment's image

> Image must be with the new name, new tag or `:latest` tag.
>
> If image is not specified with tag k8s will not pull new image with the same name when you reapply deployment.
>
> If you update an image with the same tag k8s will not pull new image also.

> also, you can use `imagePullPolicy: Always` for example in `*.yaml`

```sh
kubectl set image deployment/deployment-name container-name=repo-name/image-name:tag-name

# example
kubectl set image deployment/first-app docker-s12=account-name/repo-name:kub-first-app-v2
```

---

### rollout

check update status of the deployment after setting new image

```sh
kubectl rollout status deployment/deployment-name

# example
kubectl rollout status deployment/first-app
```

undo deployment updating

```sh
kubectl rollout undo deployment/deployment-name

# example
kubectl rollout undo deployment/first-app
```

show rollout deployment history

```sh
kubectl rollout history deployment/deployment-name

# example
kubectl rollout history deployment/first-app
```

show any rollout revision detailed

```sh
kubectl rollout history deployment/deployment-name --revision=number

# example
kubectl rollout history deployment/first-app --revision=3
```

rollback the deployment to specific revision

```sh
kubectl rollout undo deployment/deployment-name --to-revision=number

# example
kubectl rollout undo deployment/first-app --to-revision=1
```

---

### scale

scale the deployment  
create copies of pods to endure the high load and achieve high availability

```sh
kubectl scale deployment/deployment-name --replicas=number

# example
kubectl scale deployment/first-app --replicas=3
```

---
