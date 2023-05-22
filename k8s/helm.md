---
title: helm
categories:
  - software
  - IAC
  - notes
  - guides
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [helm install](#helm-install)
  - [Installing Helm with the official guide](#installing-helm-with-the-official-guide)
  - [Installing helm from brew](#installing-helm-from-brew)
  - [helm commands](#helm-commands)

## helm install

### [Installing Helm](https://helm.sh/docs/intro/install/) with the official guide

Better install with the official guide - [Installing Helm](https://helm.sh/docs/intro/install/)

Helm install one-liner Linux amd64  
don't forget to take the latest version from [git repo](https://github.com/helm/helm/releases)!

```sh
wget https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz && \
  tar -zxvf helm-v3.12.0-linux-amd64.tar.gz && \
  mv linux-amd64/helm /usr/local/bin/helm
```

### Installing helm from brew

> There might be problems with CI/CD pipelines with the **helm** from brew.
>
> For example, **Jenkins** will not use **helm** from **brew** even if the user's `PATH` and root `secret PATH` included binaries from brew.
>
> The only way to resolve it is just symlink the binary from brew like that:
>
> ```sh
> sudo ln -s /home/linuxbrew/.linuxbrew/bin/helm /usr/local/bin/helm
> ```

```sh
brew install helm
```

### helm commands

create helm charts in current dir (or repo)

```sh
helm create charts-name

# example
helm create vprofilecharts
```

test helm charts example

```sh
# create test namespace
kubectl create namespace test

# install all deployments from helm charts specifying the image, that is variable in app deployment YAML file
helm install --namespace test vprofile-stack helm/vprofilecharts --set appimage=imranvisualpath/vproappdock:9

# check deployments with helm
helm list --namespace test

check all deployments in namespace
kubectl get all --namespace test

# delete all deployments with helm
helm delete vprofile-stack --namespace test

# delete namespace
kubectl delete namespace test
```

---
