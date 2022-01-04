# MyfirstGKEprojectwithtearraform
#this is flask based app which used mongodb to store data. You can simply create records using the app#

Image chosen: FROM python:alpine3.7 (pyhton/alpine: as we have to bother about needed lib and bin to run our app and also we can have small image for easy shipping. )

1. Created GCP account
2. created a new project and switched to that.
3. Gone to GShell and created a directory called terraform
4. created tf files.
5. did terraform init and then plan it shown error that "Error: googleapi: Error 403: Compute Engine API has not been used in project ID before or it is disabled."
went to project page and Enabled it by visiting https://console.developers.google.com/apis/api/compute.googleapis.com/overview?project=devopstest-336815 then retried.
6. faced another error "You should enable API service - container.googleapis.com". I did the same:
$ gcloud services enable container.googleapis.com 
7. I was thinking to deploy app with normal yaml and kubectl commands. but it was not a bad idea to find best way so I decided to go with Helm.
8. As ***It was asked to have dev, stg, prd environment*** so decided to achive with help of isolation of namespaces, instead having 3 GKE cluster.
9. created Helm packages for App and for DB. created different separated values.yaml for each realms/environment.
10. did local setup for jenkins pipeline using Jenkinsfile and declerative style.
11. for prometheus I follwed simple standard tanzu document. used helm repo bitnami https://charts.bitnami.com/bitnami

references:
https://tanzu.vmware.com/developer/guides/observability-prometheus-grafana-p1/
https://stackoverflow.com/questions/61387463/uninstall-release-not-loaded-new-release-not-found-chart-deployed-using-hel
https://github.com/gruntwork-io/helm-kubernetes-services/blob/master/charts/k8s-service/values.yaml
