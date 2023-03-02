*************************************************
# k8s install macos
*************************************************

# install kubectl
brew install kubectl

# check installed kubectl
kubectl version --client





*************************************************
# minikube install macos
*************************************************

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




*************************************************
# minikube service
*************************************************

# show minikube service list
minikube service list

# create service to expose app in k8s cluster to local machine
minikube service deployment-name
minikube service first-app