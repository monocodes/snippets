*************************************************
# get
*************************************************

# show all deployments and its status
kubectl get deployments

# show all pods created by deployments
kubectl get pods





*************************************************
# create
*************************************************

# create new deployment
kubectl create deployment deployment-name --image=image-name
kubectl create deplyment first-app --image=wanderingmono/docker-s12:app-web-nodejs-kub





*************************************************
# delete
*************************************************

# delete deployment
kuvectl delete deployment deployment-name