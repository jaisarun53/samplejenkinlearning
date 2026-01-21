pipeline {
    agent any

    stages {
        stage('Compile') {
            steps {
                echo 'Hello World'
                sh 'mvn clean package'
            }
        
       post { 
        success { 
            echo 'Archiving the artifact'
            archiveArtifacts artifacts: '**/*.war', followSymlinks: false
        }
    }
}
        stage('Build docker image') {
            steps {
                echo 'building docker image'
                sh 'docker build -t myregistry.local/myapp:"$BUILD_NUMBER" .'
            }
        }
        stage('trivy scan docker image') {
            steps {
                echo 'scanning image'
                sh 'trivy image myregistry.local/myapp:"$BUILD_NUMBER"'
            }
        }
       
        stage('Upload image to docker registry') {
            steps {
                echo 'Uploading img'
            }
        }
        stage('deploy to staging env') {
            steps {
                echo 'staging env'
                sh '''
                docker stop myapp-staging || true
                docker rm  myapp-staging  || true
                docker run -d --name myapp-staging -p 9090:8080  myregistry.local/myapp:"$BUILD_NUMBER"
                  '''
            }
        }
        stage('deploy to prod env') {
            steps {
                 timeout(time:1, unit:'MINUTES'){
                 input message: 'Approve Production deployment?'
                 }
                echo 'prod deployment'
                sh '''
                docker stop myapp-production || true
                docker rm  myapp-production  || true
                docker run -d --name myapp-production -p 9091:8080  myregistry.local/myapp:"$BUILD_NUMBER"
                  '''
            }
        }
    }
}
