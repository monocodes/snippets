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
    - [k8s install macos](#k8s-install-macos)
    - [minikube install macos](#minikube-install-macos)
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

### k8s install macos

install kubectl

```bash
brew install kubectl
```

check installed kubectl

```bash
kubectl version --client
```

---

### minikube install macos

minikube - local virtualized k8s cluster.

```bash
brew install minikube
```

>if docker desktop installed you could use docker to create VM for k8s cluster

start minikube with docker driver

```bash
minikube start
```

check minkube status

```bash
minikube status
```

start minikube web dashboard

```bash
minikube dashboard
```

---

#### minikube service

show minikube service list

```bash
minikube service list
```

create service to expose app in k8s cluster to local machine

```bash
minikube service deployment-name

# example
minikube service first-app
```

---

## k8s commands

### get

show all deployments and its status

```bash
kubectl get deployments
```

show all pods created by deployments

```bash
kubectl get pods
```

show all services

```bash
kubectl get service
```

---

### apply

start the deployment from `*.yaml` file

> use multiple `-f` in command to deploy something, or use comma  
> `-f` = file

```bash
kubectl apply -f=deployment-name.yaml,deployment-name2.yaml

# example
kubectl apply -f=deployment.yaml
```

>Can change anything in deployment just changing the `*.yaml` files and apply them again. For example, change number of replicas or image.

---

### delete

delete service

```bash
kubectl delete service service-name
```

delete deployment

```bash
kuvectl delete deployment deployment-name

kubectl delete deployments.apps deployment-name
```

delete multiple deployments that was applied with `kubectl apply -f`

```bash
kubectl delete -f=deployment-name.yaml

# example
kubectl delete -f=deployment.yaml,service.yaml
```

delete multiple objects using labels

> objects need to be labeled  
> in command you must include object types (e. g. deployments, services)  
> `-l` = label

```bash
kubectl delete deployments,services -l key=value

# example
kubectl delete deployments,services -l group=example 
```

---

### create

create new deployment

```bash
kubectl create deployment deployment-name --image=image-name

# example
kubectl create deployment first-app --image=account-name/repo-name:app-web-nodejs-kub
```

to create multiple containers based on images separate images with comma

```bash
kubectl create deployment deployment-name --image=image-name,image-name2
```

---

### expose

expose port of the running deployment with load balancer  
actually it creates a service object

```bash
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

```bash
kubectl set image deployment/deployment-name container-name=repo-name/image-name:tag-name

# example
kubectl set image deployment/first-app docker-s12=account-name/repo-name:kub-first-app-v2
```

---

### rollout

check update status of the deployment after setting new image

```bash
kubectl rollout status deployment/deployment-name

# example
kubectl rollout status deployment/first-app
```

undo deployment updating

```bash
kubectl rollout undo deployment/deployment-name

# example
kubectl rollout undo deployment/first-app
```

show rollout deployment history

```bash
kubectl rollout history deployment/deployment-name

# example
kubectl rollout history deployment/first-app
```

show any rollout revision detailed

```bash
kubectl rollout history deployment/deployment-name --revision=number

# example
kubectl rollout history deployment/first-app --revision=3
```

rollback the deployment to specific revision

```bash
kubectl rollout undo deployment/deployment-name --to-revision=number

# example
kubectl rollout undo deployment/first-app --to-revision=1
```

---

### scale

scale the deployment  
create copies of pods to endure the high load and achieve high availability

```bash
kubectl scale deployment/deployment-name --replicas=number

# example
kubectl scale deployment/first-app --replicas=3
```

---
