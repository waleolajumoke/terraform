#NB: Remeber to assign the created role to your EC2

#To Create EKS cluster in your region using eksctl (version 1.30 and above)
eksctl create cluster --name kubernetes-cluster --version 1.30 --region us-east-1 --nodegroup-name linux-nodes --node-type t2.xlarge --nodes 2 


#To get context information of kubernetes cluster
cat /home/ubuntu/.kube/config 

#To create namespace in kubernetes cluster
kubectl create namespace devsecops

#To get deployments in a namespace in kubernetes cluster
kubectl get deployments --namespace=devsecops 

#To get services in a namespace in kubernetes cluster
kubectl get svc --namespace=devsecops 

#To delete everything in a namespace in kubernetes cluster
kubectl delete all --all -n devsecops 


#To Delete EKS cluster
eksctl delete cluster --region=us-east-1 --name=kubernetes-cluster #delete eks cluster

#To delete unused docker images to cleanup memeory on system 
docker system prune  

#To delete a docker image
docker image rm imagename  

