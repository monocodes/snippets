---
title: k8s
categories:
  - software
  - CI/CD
  - notes
  - guides
author: wandering-mono
url: https://github.com/monocodes/snippets.git
---

# k8s

- [k8s](#k8s)
  - [k8s install](#k8s-install)
    - [kubectl paths](#kubectl-paths)
    - [Linux](#linux)
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
    - [run](#run)
    - [expose](#expose)
    - [set](#set)
    - [rollout](#rollout)
    - [scale](#scale)
  - [k8s notes](#k8s-notes)
    - [Namespace](#namespace)
      - [Namespaces documentation](#namespaces-documentation)
  - [kops](#kops)
    - [kops commands](#kops-commands)
      - [devops-project-ud-01-21 examples](#devops-project-ud-01-21-examples)

## k8s install

### kubectl paths

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

### Linux

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

show everything in current namespace

```sh
kubectl get all
```

show everything in all namespaces

```sh
kubectl get all --all-namespaces
```

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
kubectl get svc
kubectl get service
```

show services from namespace

```sh
kubectl get svc -n kube-system
```

show namespaces

```sh
kubectl get ns
kubectl get namespaces
```

---

### apply

start the deployment from `*.yaml` file

> use multiple `-f` in command to deploy something, or use comma  
> `-f` = file

```sh
kubectl apply -f deployment-name.yaml,deployment-name2.yaml

# example
kubectl apply -f deployment.yaml
kubectl apply -f pod.yaml
```

>Can change anything in deployment just changing the `*.yaml` files and apply them again. For example, change number of replicas or image.

---

### delete

delete namespace - **ATTENTION!** it will delete everything in namespace

```sh
kubectl delete ns namespace-name

# example
kubectl delete ns kubekart
```

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
kubectl delete -f deployment-name.yaml

# example
kubectl delete -f deployment.yaml,service.yaml
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

create namespace

```sh
kubectl create ns namespace-name
```

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

### run

run new pod in **default** namespace

```sh
kubectl run pod-name --image=image-name

# example
kubectl run nginx1 --image=nginx
```

run new pod in specified namespace

```sh
kubectl run pod-name --image=image-name -n namespace-name

# example
kubectl run nginx1 --image=nginx -n kubekart
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

## k8s notes

### Namespace

Setting the namespace preference.  
You can permanently save the namespace for all subsequent kubectl commands in that context.

```sh
kubectl config set-context --current --namespace=<insert-namespace-name-here>
# Validate it
kubectl config view --minify | grep namespace:
```

#### [Namespaces documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)

In Kubernetes, *namespaces* provides a mechanism for isolating groups of resources within a single cluster. Names of resources need to be unique within a namespace, but not across namespaces. Namespace-based scoping is applicable only for namespaced objects *(e.g. Deployments, Services, etc)* and not for cluster-wide objects *(e.g. StorageClass, Nodes, PersistentVolumes, etc)*.

[When to Use Multiple Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/#when-to-use-multiple-namespaces)

Namespaces are intended for use in environments with many users spread across multiple teams, or projects. For clusters with a few to tens of users, you should not need to create or think about namespaces at all. Start using namespaces when you need the features they provide.

Namespaces provide a scope for names. Names of resources need to be unique within a namespace, but not across namespaces. Namespaces cannot be nested inside one another and each Kubernetes resource can only be in one namespace.

Namespaces are a way to divide cluster resources between multiple users (via [resource quota](https://kubernetes.io/docs/concepts/policy/resource-quotas/)).

It is not necessary to use multiple namespaces to separate slightly different resources, such as different versions of the same software: use [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels) to distinguish resources within the same namespace.

> **Note:** For a production cluster, consider *not* using the `default` namespace. Instead, make other namespaces and use those.

**Initial namespaces**

Kubernetes starts with four initial namespaces:

- `default`

  Kubernetes includes this namespace so that you can start using your new cluster without first creating a namespace.

- `kube-node-lease`

  This namespace holds [Lease](https://kubernetes.io/docs/concepts/architecture/leases/) objects associated with each node. Node leases allow the kubelet to send [heartbeats](https://kubernetes.io/docs/concepts/architecture/nodes/#heartbeats) so that the control plane can detect node failure.

- `kube-public`

  This namespace is readable by *all* clients (including those not authenticated). This namespace is mostly reserved for cluster usage, in case that some resources should be visible and readable publicly throughout the whole cluster. The public aspect of this namespace is only a convention, not a requirement.

- `kube-system`

  The namespace for objects created by the Kubernetes system.

---

## kops

install kops

```sh
brew install kops
```

### kops commands

#### devops-project-ud-01-21 examples

With this commands, you can create HA cluster in AWS, for example. Before that you need to configure `awscli`, `kubectl`, `kops` and provide user in **AWS** with admin rights.

`s3://vprofile-kops-state-mono` is the S3 bucket where `kops` could store config.

create cluster

```sh
kops create cluster \
  --name=kubevpro.wandering-mono.top \
  --state=s3://vprofile-kops-state-mono \
  --zones=us-east-1a,us-east-1b \
  --node-count=2 \
  --node-size=t3a.small \
  --master-size=t3a.medium \
  --dns-zone=kubevpro.wandering-mono.top \
  --node-volume-size=8 \
  --master-volume-size=8
```

update cluster - it's like *apply* after every command or `--yes` statement can be used

```sh
kops update cluster \
  --name kubevpro.wandering-mono.top \
  --state=s3://vprofile-kops-state-mono \
  --yes \
  --admin
```

check cluster during 10 minutes until it will be fully operational

```sh
kops validate cluster \
  --name kubevpro.wandering-mono.top \
  --state=s3://vprofile-kops-state-mono \
  --wait 10m
```

**shutdown cluster and bring all nodes down**

- show cluster nodes

  ```sh
  kops get ig --state=s3://vprofile-kops-state-mono
  
  # output
  Using cluster from kubectl context: kubevpro.wandering-mono.top
  
  NAME				ROLE		MACHINETYPE	MIN	MAX	ZONES
  control-plane-us-east-1a	ControlPlane	t3a.medium	1	1	us-east-1a
  nodes-us-east-1a		Node		t3a.small	1	1	us-east-1a
  nodes-us-east-1b		Node		t3a.small	1	1	us-east-1b
  ```

- edit configs of all nodes, including `ControlPlane` node, change `maxSize` and `minSize` to `0`

  ```sh
  kops edit ig nodes-us-east-1b --state=s3://vprofile-kops-state-mono
  kops edit ig nodes-us-east-1a --state=s3://vprofile-kops-state-mono
  kops edit ig control-plane-us-east-1a --state=s3://vprofile-kops-state-mono
  ```

- update cluster

  ```sh
  kops update cluster --yes --state=s3://vprofile-kops-state-mono
  ```

- changes may require instances to restart

  ```sh
  kops rolling-update cluster --state=s3://vprofile-kops-state-mono
  ```

- to turn your cluster back on, revert the settings, changing your master to at least 1, and your nodes to your liking

delete cluster

```sh
kops delete cluster \
  --name=kubevpro.wandering-mono.top \
  --state=s3://vprofile-kops-state-mono \
  --yes
```

---
