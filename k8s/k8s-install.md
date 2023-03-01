*************************************************
# k8s minikube local setup for macos
*************************************************

# install kubectl
brew install kubectl

# check installed kubectl
kubectl version --client

# install minikube - local virtualized k8s cluster
brew install minikube

<!-- if docker desktop installed you could use
docker to create VM for k8s cluster -->
# start minikube with docker driver
minikube start

# check minkube status
minikube status

# start minikube web dashboard
minikube dashboard