# Making a pod control the cluster
Make a cluster (if you not already have one):
* gcloud container clusters create mycluster --region europe-north1-a -m f1-micro

Give some permissions to the pods, setting them as masters:
* kubectl apply -f auth.yaml 

Test by running interactive container:
* kubectl run test -i --tty  --image=klenow/kbctl
* try running command like kubectl get pods inside...

OBS:
* This should not just be run as above but as a service running a jolie script executing the commands. 