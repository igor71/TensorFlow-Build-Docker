pipeline {
  agent {label 'yi-tensorflow'}
    stages {
        stage('Create Build Docker For Tensorflow-CPU-MKL') {
            steps {
	              sh 'docker build -f Dockerfile.devel-cpu-mkl -t yi/tflow:0.0 .'  
            }
        }
	      stage('Test The yi/tflow:0.0 Docker Image') { 
            steps {
                sh '''#!/bin/bash -xe
		              echo 'Hello, YI-TFLOW!!'
                    image_id="$(docker images -q yi/tflow:0.0)"
                      if [[ "$(docker images -q yi/tflow:0.0 2> /dev/null)" == "$image_id" ]]; then
                          docker inspect --format='{{range $p, $conf := .RootFS.Layers}} {{$p}} {{end}}' $image_id
                      else
                          echo "It appears that current docker image corrapted!!!"
                          exit 1
                      fi 
                   ''' 
            }
        }
    }
	post {
            always {
               script {
                  if (currentBuild.result == null) {
                     currentBuild.result = 'SUCCESS' 
                  }
               }
               step([$class: 'Mailer',
                     notifyEveryUnstableBuild: true,
                     recipients: "igor.rabkin@xiaoyi.com",
                     sendToIndividuals: true])
            }
         } 
}
