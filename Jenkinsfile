pipeline {
  agent {label 'yi-tensorflow'}
    stages {
        stage('Create Build Docker For Tensorflow-CPU-MKL') {
         steps {
	        sh 'docker build -t yi/tflow:0.0 .'  
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
	    stage('Save & Load Docker Image') { 
            steps {
                sh '''#!/bin/bash -xe
		        echo 'Saving Docker image into tar archive'
                        docker save yi/tflow:0.0 | pv | cat > $WORKSPACE/yi-tflow-0.0.tar
			
                        echo 'Remove Original Docker Image' 
			CURRENT_ID=$(docker images | grep -E '^yi/tflow-vnc.*0.0'' | awk -e '{print $3}')
			docker rmi -f yi/tflow:0.0
			
                        echo 'Loading Docker Image'
                        pv $WORKSPACE/yi-tflow-0.0.tar | docker load
			docker tag $CURRENT_ID yi/tflow:0.0
                        
                        echo 'Removing temp archive.'  
                        rm $WORKSPACE/yi-tflow-0.0.tar
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
