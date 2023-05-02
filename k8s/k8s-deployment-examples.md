---
title: k8s-deployment-examples
categories:
  - software
  - CI/CD
  - examples
author: wandering-mono
url: https://github.com/monocodes/snippets.git
---

- [devops-project-ud-01](#devops-project-ud-01)
  - [234. Pods](#234-pods)
  - [236. Service](#236-service)
- [docker-edu](#docker-edu)
  - [docker-s12-deployment.yaml](#docker-s12-deploymentyaml)
  - [docker-s12-master-deployment.yaml](#docker-s12-master-deploymentyaml)
  - [docker-s12-service.yaml](#docker-s12-serviceyaml)

## devops-project-ud-01

### 234. Pods

`vproapp-pod.yaml` - vprofile app image with tomcat java app

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: vproapp
  labels:
    app: vproapp
spec:
  containers:
    - name: appcontainer
      image: wanderingmono/vprofileapp:V1
      ports:
        - name: vproapp-port
          containerPort: 8080
```

---

### 236. Service

`vproapp-nodeport-svc.yaml` - service with exposed port for `vproapp-pod.yaml`

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: helloworld-service
spec:
  ports:
  - port: 8090
    nodePort: 30001
    targetPort: vproapp-port
    protocol: TCP
  selector:
    app: vproapp
  type: NodePort
```

`vproapp-loadbalancer-svc.yaml` - service load balancer for `vproapp-pod.yaml`

```yaml
---
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

---

### 237. ReplicaSet

`replset.yaml` - actually, don't need to use **ReplicaSet**, use **Deployment**

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
  replicas: 5
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

---

### 238. Deployment

`deployment.yaml` - simple nginx deployment

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

---

### 239. Command and Arguments

`com.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: command-demo
  labels:
    purpose: demonstrate-command
spec:
  containers:
  - name: command-demo-container
    image: debian
    command: ["printenv"]
    args: ["HOSTNAME", "KUBERNETES_PORT"]
  restartPolicy: OnFailure
```

`com2.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: command-demo2
  labels:
    purpose: demonstrate-command
spec:
  containers:
  - name: command-demo-container
    image: debian
    env:
    - name: MESSAGE
      value: "hello world"
    command: ["/bin/echo"]
    args: ["$(MESSAGE)"]
  restartPolicy: OnFailure
```

---

### 240. Volumes

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

---

## docker-edu

### docker-s12-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: second-app-deployment
  labels:
    group: example
spec:
  replicas: 1
  selector:
    matchLabels:
      app: second-app
      tier: backend
    # matchExpressions:
    #   - {key: app, operator: In, values: [second-app, first-app]}
    # matchExpressions is more powerful and
    # complex method to work with labels and
    # selectors
  template:
    metadata:
      labels:
        app: second-app
        tier: backend
    spec:
      containers:
        - name: second-node
          image: wanderingmono/docker-s12:kub-first-app-v2
          imagePullPolicy: Always
          # imagePullPolicy: Never
          livenessProbe:
            httpGet:
              path: /
              port: 8080
            periodSeconds: 10
            initialDelaySeconds: 5
        # to create multiple containers
        # - name: ...
        #   image: ...
```

---

### docker-s12-master-deployment.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: second-app
  ports:
    - protocol: 'TCP'
      port: 80
      targetPort: 8080
      # to expose multiple ports
    # - protocolol: 'TCP'
    #   port: 443
    #   targetPort: 443
  type: LoadBalancer
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: second-app-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: second-app
      tier: backend
  template:
    metadata:
      labels:
        app: second-app
        tier: backend
    spec:
      containers:
        - name: second-node
          image: wanderingmono/docker-s12:kub-first-app-v2
        # to create multiple containers
        # - name: ...
        #   image: ...
```

---

### docker-s12-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
  labels:
    group: example
spec:
  selector:
    app: second-app
  ports:
    - protocol: 'TCP'
      port: 80
      targetPort: 8080
      # to expose multiple ports
    # - protocolol: 'TCP'
    #   port: 443
    #   targetPort: 443
  type: LoadBalancer
```

---
