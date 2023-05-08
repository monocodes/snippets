---
title: k8s-deployment-examples
categories:
  - software
  - CI/CD
  - examples
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [devops-project-ud-01](#devops-project-ud-01)
  - [Section 21 - Kubernetes](#section-21---kubernetes)
    - [234. Pods](#234-pods)
    - [236. Service](#236-service)
    - [237. ReplicaSet](#237-replicaset)
    - [238. Deployment](#238-deployment)
    - [239. Command and Arguments](#239-command-and-arguments)
    - [240. Volumes](#240-volumes)
  - [Section 22 - App Deployment on Kubernetes Cluster](#section-22---app-deployment-on-kubernetes-cluster)
    - [Vprofile app in k8s cluster](#vprofile-app-in-k8s-cluster)
- [docker-edu](#docker-edu)
  - [docker-s12-deployment.yaml](#docker-s12-deploymentyaml)
  - [docker-s12-master-deployment.yaml](#docker-s12-master-deploymentyaml)
  - [docker-s12-service.yaml](#docker-s12-serviceyaml)

## devops-project-ud-01

### Section 21 - Kubernetes

#### 234. Pods

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

#### 236. Service

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

#### 237. ReplicaSet

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

#### 238. Deployment

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

#### 239. Command and Arguments

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

#### 240. Volumes

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

### Section 22 - App Deployment on Kubernetes Cluster

#### Vprofile app in k8s cluster

Minimum `kops` setup

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

`app-secret.yaml`

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
data:
  db-pass: dnByb2RicGFzcw==
  rmq-pass: Z3Vlc3Q=
```

`db-CIP.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: vprodb
spec:
  selector:
    app: vprodb
  ports:
    - port: 3306
      targetPort: vprodb-port
      protocol: TCP
  type: ClusterIP
```

`mc-CIP.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: vprocache01
spec:
  selector:
    app: vpromc
  ports:
    - port: 11211
      targetPort: vpromc-port
      protocol: TCP
  type: ClusterIP
```

`mcdep.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vpromc
  labels:
    app: vpromc
spec:
  selector:
    matchLabels:
      app: vpromc
  replicas: 1
  template:
    metadata:
      labels:
        app: vpromc
    spec:
      containers:
        - name: vpromc
          image: memcached
          ports:
            - name: vpromc-port
              containerPort: 11211
```

`rmq-CIP.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: vpromq01
spec:
  selector:
    app: vpromq01
  ports:
    - port: 15672
      targetPort: vpromq01-port
      protocol: TCP
  type: ClusterIP
```

`rmq-dep.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vpromq01
  labels:
    app: vpromq01
spec:
  selector:
    matchLabels:
      app: vpromq01
  replicas: 1
  template:
    metadata:
      labels:
        app: vpromq01
    spec:
      containers:
        - name: vpromq01
          image: rabbitmq
          ports:
            - name: vpromq01-port
              containerPort: 15672
          env:
            - name: RABBITMQ_DEFAULT_PASS
              valueFrom:
                secretKeyRef:
                  name: app-secret
                  key: rmq-pass
            - name: RABBIT_DEFAULT_USER
              value: "guest"
```

`vproapp-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: vproapp-service
spec:
  selector:
    app: vproapp
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: vproapp-port
      protocol: TCP
```

`vproappdep.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vproapp
  labels:
    app: vproapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: vproapp
  template:
    metadata:
      labels:
        app: vproapp
    spec:
      containers:
        - name: vproapp
          image: vprofile/vprofileapp:V1 # my image don't work with rmq, maybe because of pass mismatch
          ports:
          - name: vproapp-port
            containerPort: 8080
      initContainers: # initContainers to not run app pod before db and mc pods
        - name: init-mydb
          image: busybox
          command: ['sh', '-c', 'until nslookup vprodb.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for mydb; sleep 2; done;']
        - name: init-memcache
          image: busybox
          command: ['sh', '-c', 'until nslookup vprocache01.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for memcache; sleep 2; done;']
```

`vprodbdep.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vprodb
  labels:
    app: vprodb
spec:
  selector:
    matchLabels:
      app: vprodb
  replicas: 1
  template:
    metadata:
      labels:
        app: vprodb
    spec:
      containers:
        - name: vprodb
          image: wanderingmono/vprofiledb:V1
          args:
            - "--ignore-db-dir=lost+found"
          volumeMounts:
            - mountPath: /var/lib/mysql
              name: vpro-db-data
          ports:
            - name: vprodb-port
              containerPort: 3306
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: app-secret
                  key: db-pass
      nodeSelector:
        zone: us-east-1a
      volumes:
        - name: vpro-db-data
          awsElasticBlockStore:
            volumeID: vol-03365dbf1ef7959e1
            fsType: ext4
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
