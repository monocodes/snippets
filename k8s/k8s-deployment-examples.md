---
title: k8s-deployment-examples
categories:
  - software
  - CI/CD
  - examples
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# k8s-deployment-examples

- [k8s-deployment-examples](#k8s-deployment-examples)
  - [docker-s12-deployment.yaml](#docker-s12-deploymentyaml)
  - [docker-s12-master-deployment.yaml](#docker-s12-master-deploymentyaml)
  - [docker-s12-service.yaml](#docker-s12-serviceyaml)

## docker-s12-deployment.yaml

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

## docker-s12-master-deployment.yaml

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

## docker-s12-service.yaml

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
