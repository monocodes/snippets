*************************************************
# get
*************************************************

# show all deployments and its status
kubectl get deployments

# show all pods created by deployments
kubectl get pods

# showl all services
kubectl get service




*************************************************
# apply
*************************************************

# start the deployment from *.yaml file
# you can use multiple -f in command to deploy something, or use comma
# -f = file
kubectl apply -f=deployment-name.yaml,deployment-name2.yaml
kubectl apply -f=deployment-name.yaml -f=deployment-name2.yaml
# example
kubectl apply -f=deployment.yaml

<!-- you can change anything in deployment just changing the *.yaml files
and apply them again. for example, change number of replicas or image  -->





*************************************************
# delete
*************************************************

# delete service
kubectl delete service service-name

# delete deployment
kuvectl delete deployment deployment-name
kubectl delete deployments.apps deployment-name

# delete multiple deployments that was applied with kubectl apply -f
kubectl delete -f=deployment-name.yaml
# example
kubectl delete -f=deployment.yaml,service.yaml

# delete multiple objects using labels and
# objects need to be labeled
# in command you must include object types (e. g. deployments, services)
# -l = label
kubectl delete deployments,services -l key=value
# example
kubectl delete deployments,services -l group=example 





*************************************************
# create
*************************************************

# create new deployment
kubectl create deployment deployment-name --image=image-name
# example
kubectl create deplyment first-app --image=wanderingmono/docker-s12:app-web-nodejs-kub

# to create multiple containers based on images separate images with comma
kubectl create deployment deployment-name --image=image-name,image-name2





*************************************************
# expose
*************************************************

# expose port of the running deployment with load balancer
# actually it creates a service object
kubectl expose deployment deployment-name --type=LoadBalancer --port=port-number
# example
kubectl expose deployment first-app --type=LoadBalancer --port=8080





*************************************************
# set
*************************************************

# use set to update deployment's image
# image must be with the new name, new tag or :latest tag
<!-- if image is not specified with tag k8s will not pull new image with
the same name when you reapply deployment
if you update an image with the same tag k8s will not pull new image also -->
# also, you can use imagePullPolicy: Always for example in *.yaml
kubectl set image deployment/deployment-name container-name=repo-name/image-name:tag-name
# example
kubectl set image deployment/first-app docker-s12=wanderingmono/docker-s12:kub-first-app-v2



-------------------------------------------------
# rollout
-------------------------------------------------

# check update status of the deployment after setting new image
kubectl rollout status deployment/deployment-name
# example
kubectl rollout status deployment/first-app

# undo deployment updating
kubectl rollout undo deployment/deployment-name
# example
kubectl rollout undo deployment/first-app

# show rollout deployment history
kubectl rollout history deployment/deployment-name
# example
kubectl rollout history deployment/first-app

# show any rollout revision detailed 
kubectl rollout history deployment/deployment-name --revision=number
# example
kubectl rollout history deployment/first-app --revision=3

# rollback the deployment to specific revision 
kubectl rollout undo deployment/deployment-name --to-revision=number
# example
kubectl rollout undo deployment/first-app --to-revision=1




*************************************************
# scale
*************************************************

# scale the deployment
# create copies of pods to endure the high load and achieve high availability
kubectl scale deployment/deployment-name --replicas=number
# example
kubectl scale deployment/first-app --replicas=3