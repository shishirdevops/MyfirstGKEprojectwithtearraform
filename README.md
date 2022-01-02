# MyfirstGKEprojectwithtearraform

1. Created GCP account
2. created a new project and switched to that.
3. Gone to GShell and created a directory called terraform
4. created tf files.
5. did terraform init and then plan it shown error that "Error: googleapi: Error 403: Compute Engine API has not been used in project ID before or it is disabled."
went to project page and Enabled it by visiting https://console.developers.google.com/apis/api/compute.googleapis.com/overview?project=devopstest-336815 then retried.
6. You should enable API service - container.googleapis.com:
$ gcloud services enable container.googleapis.com 
7. 
