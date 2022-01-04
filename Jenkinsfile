pipeline{
agent any
stages{
      stage("build docker image") {
             steps {
                    sh "docker build -t shishirdevops/tasksapp-python:1.0.0 ."
                    }
        }
     stage("push docker image to registry") {
             steps {
                   sh "docker push shishirdevops/tasksapp-python:1.0.0"
                    }
        }
        stage('Deploy App') {
            parallel {
                        stage('Deploy to Dev') {
	        steps {
	sh "helm install taskapp appcharthelm -n dev -f appcharthelm/dev-values.yaml && helm install taskdb db -n dev -f db/dev-values.yaml"
	}
                        stage('Deploy to Stg') {
	       steps {
	sh "helm install taskdb db -n stg -f db/stg-values.yaml && helm install taskapp appcharthelm -n stg -f appcharthelm/stg-values.yaml"
	      }
	   } 
	} 
     }
   stage('Sanity check') {
	steps { input "Does the staging environment look ok?"	}
	}
   stage('Deploy to Prd') {
	steps {
	sh "helm install taskapp appcharthelm -n prd -f appcharthelm/values.yaml && helm install taskdb db -n prd -f db/values.yaml"
	}
	}
          }
        }
