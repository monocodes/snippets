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
  - [kubectl get](#kubectl-get)
  - [kubectl describe](#kubectl-describe)
  - [kubectl label](#kubectl-label)
  - [kubectl logs](#kubectl-logs)
  - [kubectl edit](#kubectl-edit)
  - [kubectl apply ~ kubectl create](#kubectl-apply--kubectl-create)
  - [kubectl delete](#kubectl-delete)
  - [kubectl run](#kubectl-run)
  - [kubectl expose](#kubectl-expose)
  - [kubectl set](#kubectl-set)
  - [kubectl rollout](#kubectl-rollout)
  - [kubectl scale](#kubectl-scale)
  - [kubectl exec](#kubectl-exec)
- [k8s network](#k8s-network)
- [k8s objects](#k8s-objects)
  - [Pod](#pod)
  - [Service](#service)
  - [ReplicaSet](#replicaset)
  - [ReplicationController](#replicationcontroller)
  - [Deployment](#deployment)
  - [Volumes](#volumes)
  - [ConfigMaps](#configmaps)
    - [Injecting ConfigMap data as environmental variables](#injecting-configmap-data-as-environmental-variables)
    - [Injecting ConfigMap data as volumes](#injecting-configmap-data-as-volumes)
  - [Secret](#secret)
    - [example 1](#example-1)
    - [example 2](#example-2)
  - [Ingress](#ingress)
    - [Ingress example with vprofile project](#ingress-example-with-vprofile-project)
  - [Taints and Tolerations](#taints-and-tolerations)
  - [Resource Management for Pods and Containers](#resource-management-for-pods-and-containers)
  - [Jobs](#jobs)
  - [Cronjob](#cronjob)
  - [DaemonSet](#daemonset)
- [k8s notes](#k8s-notes)
  - [Namespace](#namespace)
    - [Namespaces documentation](#namespaces-documentation)
- [kops](#kops)
  - [kops commands](#kops-commands)
    - [devops-project-ud-01-21 examples](#devops-project-ud-01-21-examples)
    - [Shutdown cluster and bring all nodes down](#shutdown-cluster-and-bring-all-nodes-down)

## k8s install

### kubectl paths

kubectl configuration

```sh
~/.kube/config
```

show kubectl config without certs

```sh
kubectl config view
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

### kubectl get

show everything in current Namespace

```sh
kubectl get all
```

show everything in specified namespace

```sh
kubectl get all -n namespace-name

# example
kubectl get all -n ingress-nginx
```

show everything in all Namespaces

```sh
kubectl get all --all-namespaces
```

show something continuosly

```sh
kubectl get type-name --watch

# example
kubectl get ingress --watch
```

show all Nodes

```sh
kubectl get nodes
```

show all labels for nodes

```sh
kubectl get nodes --show-lables
```

show all Deployments and its status

```sh
kubectl get deploy
kubectl get deployments
```

show all Pods created by deployments

```sh
kubectl get pods
```

show all Services

```sh
kubectl get svc
kubectl get service
```

show Services from namespace

```sh
kubectl get svc -n kube-system
```

show Namespaces

```sh
kubectl get ns
kubectl get namespaces
```

show ReplicaSets

```sh
kubectl get rs
kubectl get replicaset
```

show ConfigMaps

```sh
kubectl get cm
kubectl get configmap
kubectl get cm db-config -o yaml
```

describe object fully

```sh
kubectl get object-type object-name -o format

# example
kubectl get pod webapp-pod -o yaml
```

describe object briefly with more info, including ip address

```sh
kubectl get object-type -o wide

# example
kubectl get pod -o wide
```

describe object in file

```sh
kubectl get object-type object-name -o format > filename

# example
kubectl get pod webapp-pod -o yaml > webpod-definition.yaml
```

---

### kubectl describe

show extensive info about object including last events

```sh
kubectl describe object-type object-name

# example
kubectl describe pod webapp-pod
kubectl describe svc webapp-service
kubectl describe cm db-config
```

---

### kubectl label

label node

```sh
kubectl label node-name key-name=value-name

# example
kubectl label nodes i-01c0e0a46f6cecc50 zone=us-east-1a
```

---

### kubectl logs

show logs of the object, the full output of the container process

```sh
kubectl logs object-name

# example
kubectl logs web2
```

---

### kubectl edit

edit object

```sh
kubectl edit object-type object-name

# example
kubectl edit pod webapp-pod
kubectl edit rs frontend
kubectl edit replicaset/frontend
```

---

### kubectl apply ~ kubectl create

start the deployment from YAML file

> use multiple `-f` in command to deploy something, or use comma  
> `-f` = file

```sh
kubectl apply -f deployment-name.yaml,deployment-name2.yaml

# example
kubectl apply -f deployment.yaml
kubectl apply -f pod.yaml
```

>Can change anything in deployment just changing the `*.yaml` files and apply them again. For example, change number of replicas or image.

create all objects from YAML files

```sh
kubectl create -f .
# or use kubectl apply to not redeploy existing objects
kubectl apply -f .
```

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

create multiple containers based on images separate images with comma

```sh
kubectl create deployment deployment-name --image=image-name,image-name2
```

create any object from file

```sh
kubectl create -f filename.yaml

# check object after creation
kubectl get object-name

# examples
# pod
kubectl create -f vproapp-pod.yaml
kubectl get pod
kubectl describe pod vproapp

# service
kubectl create -f vproapp-nodeport-svc.yaml
kubectl get svc
kubectl describe svc helloworld-service
```

create ConfigMap - avoid creating ConfigMaps imperatively

```sh
kubectl create configmap db-config \
	--from-literal=MYSQL_DATABASE=accounts \
	--from-literal=MYSQL_ROOT_PASSWORD=somecomplexpass \

# output
configmap/db-config created

# check created ConfigMap
kubectl get cm
kubectl get cm db-config -o yaml
```

create Secret - avoid creating Secrets imperatively

```sh
kubectl create secret generic db-secret \
	--from-literal=MYSQL_ROOT_PASSWORD=somecomplexpassword
	
# output
secret/db-secret created

# check created Secret, value will be encoded, NOT ENCRYPTED
kubectl get secret db-secret
kubectl get secret db-secret -o yaml
```

create Secret from file

```sh
# Create files needed for example
echon -n 'admin' > ./username.txt
echo -n '1f2d1e2e67df' > ./password.txt

kubectl create secret generic db-user-pass \
	--from-file=./username.txt \
	--from-file=./password.txt
```

**Create manifest for deployment from the `create` command**

1. ```sh
   kubectl create deployment ngdep --image=nginx --dry-run=client -o yaml > ngdep.yaml
   ```

2. `ngdep.yaml`

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     creationTimeStamp: null
     labels:
       app: ngdep
     name: ngdep
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: ngdep
     strategy: {}
     template:
       metadata:
         creationTimeStamp: null
         labels:
           app: ngdep
       spec:
         containers:
         - image: nginx
           name: nginx
           resources: {}
   status: {}
   ```

---

### kubectl delete

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

### kubectl run

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

run new pod and run specified command

```sh
kubectl run object-name --image=image-name command-name

# example
kubectl run web2 --image=nginx ls
```

run pod and login into container

```sh
kubectl run -i -tty pod-name --image=image-name -- sh

# example
kubectl run -i --tty busybox --image=busybox:1.28 -- sh
```

**Create manifest for pod from the `run` command**

1. ```sh
   kubectl run nginxpod --image=nginx --dry-run=client -o yaml > ngpod.yaml
   ```

2. `ngpod.yaml`

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     creationTimestamp: null
     labels:
       run: nginxpod
     name: nginxpod
   spec:
     containers:
     - image: nginx
       name: nginxpod
       resources: {}
     dnsPolicy: ClusterFirst
     restartPolicy: Always
   status: {}
   ```

---

### kubectl expose

expose port of the running deployment with load balancer  
actually it creates a service object

```sh
kubectl expose deployment deployment-name --type=LoadBalancer --port=port-number

# example
kubectl expose deployment first-app --type=LoadBalancer --port=8080
```

---

### kubectl set

`set` - update deployment's image

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

### kubectl rollout

check update status of the deployment after setting new image

```sh
kubectl rollout status deployment/deployment-name

# example
kubectl rollout status deployment/first-app
```

undo deployment updating

```sh
kubectl rollout undo deployment/deployment-name

# examples
kubectl rollout undo deployment/first-app
kubectl rollout undo deployment/nginx-deployment
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

### kubectl scale

scale the deployment  
create copies of pods to endure the high load and achieve high availability

```sh
kubectl scale deployment/deployment-name --replicas=number

# example
kubectl scale deployment/first-app --replicas=3
```

scale ReplicaSet with command

```sh
kubectl scale --replicas=number rs/replicaset-name
kubectl scale --replicas=number rs replicaset-name

# example
kubectl scale --replicas=1 rs/frontend
```

---

### kubectl exec

login inside pod

```sh
kubectl exec --stdin --tty pod-name -- /bin/bash
kubectl exec --stdin --tty pod-name -- /bin/sh

# example
kubectl exec --stdin --tty configmap-demo-pod -- /bin/sh
```

---

## k8s network

- Service
  - Frontend
    - **NodePort** - exposes the Service on each Node's IP at a static port (the `NodePort`). To make the node port available, Kubernetes sets up a cluster IP address, the same as if you had requested a Service of `type: ClusterIP`.
    - **LoadBalancer** - exposes the Service externally using a cloud provider's load balancer
  - Backend
    - **ClusterIP** - exposes the Service on a cluster-internal IP. Choosing this value makes the Service only reachable from within the cluster. This is the default that is used if you don't explicitly specify a `type` for a Service. You can expose the service to the public with an [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) or the [Gateway API](https://gateway-api.sigs.k8s.io/).

---

## k8s objects

### [Pod](https://kubernetes.io/docs/concepts/workloads/pods/)

*Pods* are the smallest deployable units of computing that you can create and manage in Kubernetes.

[`pods/simple-pod.yaml`](https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/pods/simple-pod.yaml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```

`pod-setup.yaml`

```yaml
apiVersion: v1 # string
kind: Pod # string
metadata: # dict
	name: webapp-pod
	labels: # dict, like tags in aws
		app: frontend
		project: infinity
spec:
	containers: # dict
		- name: httpd-container # first value name is a list
			image: httpd
			ports: # dict
				- name: http-port # first value name is a list
					containerPort: 80
```

`tom-app.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
	name: app-pod
	labels:
		app: backend
		project: infinity
spec:
	containers:
  - name: tomcat-container
    image: tomcat
    ports:
      - name: app-port
        containerPort: 8080
```

### [Service](https://kubernetes.io/docs/concepts/services-networking/service/)

In Kubernetes, a Service is a method for exposing a network application that is running as one or more [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) in your cluster.

`service-setup.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
	name: webapp-service
spec:
	type: NodePort # ClusterIP and LoadBalancer
	ports:
	- targetPort: 80 # Backend port, should be the same port app behind service listens
		port: 80 # Service internal frontend port
		nodePort: 30005 # Service external (exposed) port, that will redirect content to the app behind service
		# nodePort range: 30000-32767
		protocol: TCP
	selector:
		app: frontend
```

`vproapp-loadbalancer-svc.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: helloworld-service
spec:
  ports:
  - port: 80
    targetPort: vproapp-port
    protocol: TCP
  selector:
    app: vproapp
  type: LoadBalancer
```

`tom-svc-clusterip.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
	name: app-service
spec:
	type: ClusterIP
	ports:
	- targetPort: 8080
		port: 8080
		protocol: TCP
	selector:
		app: backend
```

### [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)

**When to use a ReplicaSet**

A ReplicaSet ensures that a specified number of pod replicas are running at any given time. However, a Deployment is a higher-level concept that manages ReplicaSets and provides declarative updates to Pods along with a lot of other useful features. Therefore, we recommend using Deployments instead of directly using ReplicaSets, unless you require custom update orchestration or don't require updates at all.

This actually means that you may never need to manipulate ReplicaSet objects: use a Deployment instead, and define your application in the spec section.

[`controllers/frontend.yaml`](https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/frontend.yaml)

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  # modify replicas according to your case
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: gcr.io/google_samples/gb-frontend:v3
```

### [ReplicationController](https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/)

A [`Deployment`](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) that configures a [`ReplicaSet`](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/) is now the recommended way to set up replication.

[`controllers/replication.yaml`](https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/replication.yaml)

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    app: nginx
  template:
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

`tom-replset.yaml`

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
	name: app-controller
spec:
	template:
		metadata:
			labels:
				app: backend
		spec:
			containers:
			- name: tomcat-container
				image: tomcat
				ports:
				- name: app-port
					containerPort: 8080
	replicas: 2
	selector:
		app: backend
```

### [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

[`controllers/nginx-deployment.yaml`](https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/nginx-deployment.yaml)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

`tom-dep.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
	name: app-controller
spec:
	template:
		metadata:
			labels:
				app: backend
		spec:
			containers:
      - name: tomcat-container
        image: tomcat
        ports:
          - name: app-port
            containerPort: 8080
	replicas: 3
	selector:
		matchLabels:
			app: backend
```

### [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)

> To attach EBS volume in AWS you need to label volume with tags like that:
>
> | Tag-name          | Cluster-name                |
> | ----------------- | --------------------------- |
> | KubernetesCluster | kubevpro.wandering-mono.top |
>
> Otherwise you'll get "Permission denied" errors.

`mysqlpod.yaml` - it's not a production solution, because data from the container will be stored in WorkerNode dir.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dbpod
spec:
  containers:
  - image: mysql:5.7
    name: mysql
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: secter
    volumeMounts:
    - mountPath: /var/lib/mysql
      name: dbvol
  volumes:
  - name: dbvol
    hostPath:
      # directory location on host
      path: /data
      # this field is optional
      type: DirectoryOrCreate
```

### [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)

A ConfigMap is an API object used to store non-confidential data in key-value pairs. [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a [volume](https://kubernetes.io/docs/concepts/storage/volumes/).

A ConfigMap allows you to decouple environment-specific configuration from your [container images](https://kubernetes.io/docs/reference/glossary/?all=true#term-image), so that your applications are easily portable.

> **Caution:** ConfigMap does not provide secrecy or encryption. If the data you want to store are confidential, use a [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) rather than a ConfigMap, or use additional (third party) tools to keep your data private.

`db-config-configmap.yaml`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
	name: db-config
data:
	MYSQL_ROOT-PASSWORD: somecomplexpass
	MYSQL_DATABASE: accounts
```

`sample-cm.yaml` - sample ConfigMap from k8s documentation

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: game-demo
data:
  # property-like keys; each key maps to a simple value
  player_initial_lives: "3"
  ui_properties_file_name: "user-interface.properties"

  # file-like keys
  game.properties: |
    enemy.types=aliens,monsters
    player.maximum-lives=5    
  user-interface.properties: |
    color.good=purple
    color.bad=yellow
    allow.textmode=true  
```

#### Injecting ConfigMap data as environmental variables

`db-pod-cm-all.yaml` - all variables will be exported to the container

```yaml
apiVersion: v1
kind: Pod
metadata:
	name: db-pod
	labels:
		app: db
		project: infinity
spec:
	containers:
		- name: mysql-container
			image: mysql:5.7
			envFrom:
				- configMapRef:
						name: db-config
      ports:
        - name: db-port
          containerPort: 3306
```

`db-pod-cm-selective.yaml` - selected variables will be exported into the container

```yaml
apiVersion: v1
kind: Pod
metadata:
	name: db-pod
	labels:
		app: db
		project: infinity
spec:
	containers:
		- name: mysql-container
			image: mysql:5.7
			env:
				- name: DB_HOST
					valueFrom:
						configMapKeyRef:
							name: db-config
							key: DB_HOST
      ports:
        - name: db-port
          containerPort: 3306
```

#### Injecting ConfigMap data as volumes

Mounting a config file as a volume has some advantages over directly importing the config file using `**envFrom: -configMapRef**`.

When you mount a config file as a volume, the file is available in the container's file system. This means that you can modify the contents of the file without having to restart the container. This is useful if you need to update the configuration of your application at runtime.

In addition, mounting a config file as a volume allows you to use tools like `**grep**` and `**sed**` to modify the contents of the file. This can be very useful if you have a large configuration file and you need to update multiple values.

On the other hand, using `**envFrom: -configMapRef**` directly imports the config map into the environment variables of the container. This can be useful if your application is designed to read configuration values from environment variables. However, it may be more difficult to modify the configuration at runtime using this approach, as you would need to update the config map and then restart the container to pick up the changes.

`sample-cm.yaml`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: game-demo
data:
  # property-like keys; each key maps to a simple value
  player_initial_lives: "3"
  ui_properties_file_name: "user-interface.properties"

  # file-like keys
  game.properties: |
    enemy.types=aliens,monsters
    player.maximum-lives=5    
  user-interface.properties: |
    color.good=purple
    color.bad=yellow
    allow.textmode=true
```

[`configmap/configure-pod.yaml`](https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/configmap/configure-pod.yaml) - injecting as environmental variables and as volumes

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmap-demo-pod
spec:
  containers:
    - name: demo
      image: alpine
      command: ["sleep", "3600"]
      env:
        # Define the environment variable
        - name: PLAYER_INITIAL_LIVES # Notice that the case is different here
                                     # from the key name in the ConfigMap.
          valueFrom:
            configMapKeyRef:
              name: game-demo           # The ConfigMap this value comes from.
              key: player_initial_lives # The key to fetch.
        - name: UI_PROPERTIES_FILE_NAME
          valueFrom:
            configMapKeyRef:
              name: game-demo
              key: ui_properties_file_name
      volumeMounts:
      - name: config
        mountPath: "/config"
        readOnly: true
  volumes:
  # You set volumes at the Pod level, then mount them into containers inside that Pod
  - name: config
    configMap:
      # Provide the name of the ConfigMap you want to mount.
      name: game-demo
      # An array of keys from the ConfigMap to create as files
      items:
      - key: "game.properties"
        path: "game.properties"
      - key: "user-interface.properties"
        path: "user-interface.properties"
```

---

### [Secret](https://kubernetes.io/docs/concepts/configuration/secret/)

#### example 1

Decode secret with base64 and use it as Secret

```sh
echo -n "somecomplexpassword" | base64

# output
c29tZWNvbXBsZXhwYXNzd29yZA==
```

`db-secret.yaml`

```yaml
apiVersion: v1
kind: Secret
metadata:
	name: mysecret
type: Opaque
data:
	my_root_pass: c29tZWNvbXBsZXhwYXNzd29yZA==
```

`db-pod-secret-all.yaml` - all secrets will be exported to the container

```yaml
apiVersion: v1
kind: Pod
metadata:
	name: db-pod
	labels:
		app: db
		project: infinity
spec:
	containers:
		- name: mysql-container
			image: mysql:5.7
			envFrom:
				- secretRef:
						name: db-secret
      ports:
        - name: db-port
          containerPort: 3306
```

`db-pod-secret-selective.yaml` - selected secrets will be exported into the container

```yaml
apiVersion: v1
kind: Pod
metadata:
	name: db-pod
	labels:
		app: db
		project: infinity
spec:
	containers:
		- name: mysql-container
			image: mysql:5.7
			env:
				- name: MYSQL_ROOT_PASSWORD
					valueFrom:
						secretKeyRef:
							name: db-secret
							key: my_root_pass
      ports:
        - name: db-port
          containerPort: 3306
```

#### example 2

Decode secret with base64 and use it as Secret

```sh
echo -n "admin" | base64
# output
YWRtaW4=

echo -n "mysecretpass" | base64
# output
bXlzZWNyZXRwYXNz
```

`mysecret.yaml`

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
data:
  username: YWRtaW4=
  password: bXlzZWNyZXRwYXNz
type: Opaque
```

`readsecret.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-env-pod
spec:
  containers:
  - name: mycontainer
    image: redis
    env:
      - name: SECRET_USERNAME
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: username
            optional: false # same as default: "mysecret" must exist
                            # and include a key named "username"
      - name: SECRET_PASSWORD
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: password
            optional: false # same as default: "mysecret" must exist
                            # and include a key named "password"
  restartPolicy: Never
```

---

### [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

An API object that manages external access to the services in a cluster, typically HTTP.

Ingress may provide load balancing, SSL termination and name-based virtual hosting.

#### Ingress example with vprofile project

1. Create NGINX Ingress Controller with this [guide](https://kubernetes.github.io/ingress-nginx/deploy/#aws)

   ```sh
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.7.0/deploy/static/provider/aws/deploy.yaml
   ```

2. Create deployment `vprodep.yaml`

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: my-app
   spec:
     selector:
       matchLabels:
         run: my-app
     replicas: 1
     template:
       metadata:
         labels:
           run: my-app
       spec:
         containers:
         - name: my-app
           image: imranvisualpath/vproappfix
           ports:
           - containerPort: 8080
   ```

3. Apply deployment

   ```sh
   kubectl apply -f vprodep.yaml
   ```

4. Create service `vprosvc.yaml`

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: my-app
   spec:
     ports:
     - port: 8080
       protocol: TCP
       targetPort: 8080
     selector:
       run: my-app
     type: ClusterIP
   ```

5. Apply service

   ```sh
   kubectl apply -f vprosvc.yaml
   ```

6. Create DNS Cname Record for LB

   - Go to your domain hosted records
   - Add CNAME record
   - Hostname -> Load balancer Endpoint URL

7. Create ingress

   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: vpro-ingress
     annotations:
       nginx.ingress.kubernetes.io/use-regex: "true"
   spec:
     ingressClassName: nginx
     rules:
     - host: vprofile.wandering-mono.top
       http:
         paths:
         - path: /
           pathType: Prefix
           backend:
             service:
               name: my-app
               port:
                 number: 8080
   ```

8. Apply ingress

   ```sh
   kubectl apply -f vproingress.yaml
   ```

9. Check in browser <http://vprofile.wandering-mono.top>

10. Delete NGINX Ingress Controller

    ```sh
    kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.7.0/deploy/static/provider/aws/deploy.yaml
    # or by deleting NGINX Ingress Controller Namespace
    ```

---

### [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)

[*Node affinity*](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) is a property of [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) that *attracts* them to a set of [nodes](https://kubernetes.io/docs/concepts/architecture/nodes/) (either as a preference or a hard requirement). *Taints* are the opposite -- they allow a node to repel a set of pods.

*Tolerations* are applied to pods. Tolerations allow the scheduler to schedule pods with matching taints. Tolerations allow scheduling but don't guarantee scheduling: the scheduler also [evaluates other parameters](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/) as part of its function.

Taints and tolerations work together to ensure that pods are not scheduled onto inappropriate nodes. One or more taints are applied to a node; this marks that the node should not accept any pods that do not tolerate the taints.

---

### [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)

When you specify a [Pod](https://kubernetes.io/docs/concepts/workloads/pods/), you can optionally specify how much of each resource a [container](https://kubernetes.io/docs/concepts/containers/) needs. The most common resources to specify are CPU and memory (RAM); there are others.

When you specify the resource *request* for containers in a Pod, the [kube-scheduler](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/) uses this information to decide which node to place the Pod on. When you specify a resource *limit* for a container, the kubelet enforces those limits so that the running container is not allowed to use more of that resource than the limit you set. The kubelet also reserves at least the *request* amount of that system resource specifically for that container to use.

---

### [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)

A Job creates one or more Pods and will continue to retry execution of the Pods until a specified number of them successfully terminate. As pods successfully complete, the Job tracks the successful completions. When a specified number of successful completions is reached, the task (ie, Job) is complete. Deleting a Job will clean up the Pods it created. Suspending a Job will delete its active Pods until the Job is resumed again.

A simple case is to create one Job object in order to reliably run one Pod to completion. The Job object will start a new Pod if the first Pod fails or is deleted (for example due to a node hardware failure or a node reboot).

You can also use a Job to run multiple Pods in parallel.

If you want to run a Job (either a single task, or several in parallel) on a schedule, see [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/).

---

### [Cronjob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)

A *CronJob* creates [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) on a repeating schedule.

CronJob is meant for performing regular scheduled actions such as backups, report generation, and so on. One CronJob object is like one line of a *crontab* (cron table) file on a Unix system. It runs a job periodically on a given schedule, written in [Cron](https://en.wikipedia.org/wiki/Cron) format.

CronJobs have limitations and idiosyncrasies. For example, in certain circumstances, a single CronJob can create multiple concurrent Jobs. See the [limitations](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#cron-job-limitations) below.

When the control plane creates new Jobs and (indirectly) Pods for a CronJob, the `.metadata.name` of the CronJob is part of the basis for naming those Pods. The name of a CronJob must be a valid [DNS subdomain](https://kubernetes.io/docs/concepts/overview/working-with-objects/names#dns-subdomain-names) value, but this can produce unexpected results for the Pod hostnames. For best compatibility, the name should follow the more restrictive rules for a [DNS label](https://kubernetes.io/docs/concepts/overview/working-with-objects/names#dns-label-names). Even when the name is a DNS subdomain, the name must be no longer than 52 characters. This is because the CronJob controller will automatically append 11 characters to the name you provide and there is a constraint that the length of a Job name is no more than 63 characters.

[`application/job/cronjob.yaml`](https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/application/job/cronjob.yaml)

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox:1.28
            imagePullPolicy: IfNotPresent
            command:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
```

---

### [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)

A *DaemonSet* ensures that all (or some) Nodes run a copy of a Pod. As nodes are added to the cluster, Pods are added to them. As nodes are removed from the cluster, those Pods are garbage collected. Deleting a DaemonSet will clean up the Pods it created.

Some typical uses of a DaemonSet are:

- running a cluster storage daemon on every node
- running a logs collection daemon on every node
- running a node monitoring daemon on every node

In a simple case, one DaemonSet, covering all nodes, would be used for each type of daemon. A more complex setup might use multiple DaemonSets for a single type of daemon, but with different flags and/or different memory and cpu requests for different hardware types.

[`controllers/daemonset.yaml`](https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/daemonset.yaml)

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd-elasticsearch
  namespace: kube-system
  labels:
    k8s-app: fluentd-logging
spec:
  selector:
    matchLabels:
      name: fluentd-elasticsearch
  template:
    metadata:
      labels:
        name: fluentd-elasticsearch
    spec:
      tolerations:
      # these tolerations are to have the daemonset runnable on control plane nodes
      # remove them if your control plane nodes should not run pods
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      - key: node-role.kubernetes.io/master
        operator: Exists
        effect: NoSchedule
      containers:
      - name: fluentd-elasticsearch
        image: quay.io/fluentd_elasticsearch/fluentd:v2.5.2
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 200Mi
        volumeMounts:
        - name: varlog
          mountPath: /var/log
      terminationGracePeriodSeconds: 30
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
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

```sh
kops create cluster \
  --name=kubevpro.wandering-mono.top \
  --state=s3://vprofile-kops-state-mono \
  --zones=us-east-1a,us-east-1b \
  --node-count=2 \
  --node-size=t2.micro \
  --master-size=t3a.small \
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

delete cluster

```sh
kops delete cluster \
  --name=kubevpro.wandering-mono.top \
  --state=s3://vprofile-kops-state-mono \
  --yes
```

#### Shutdown cluster and bring all nodes down

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

- validate cluster

  ```sh
  kops validate cluster \
    --name kubevpro.wandering-mono.top \
    --state=s3://vprofile-kops-state-mono \
    --wait 10m
  ```

- changes may require instances to restart

  ```sh
  kops rolling-update cluster --state=s3://vprofile-kops-state-mono
  ```

- to turn your cluster back on, revert the settings, changing your master to at least 1, and your nodes to your liking

---
