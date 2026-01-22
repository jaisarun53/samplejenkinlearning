pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "arunjaiswal53"
        IMAGE_NAME = "myapp"
        IMAGE_TAG = "${BUILD_NUMBER}"
        LOCAL_IMAGE = "myregistry.local/myapp:${BUILD_NUMBER}"
        REMOTE_IMAGE = "arunjaiswal53/myapp:${BUILD_NUMBER}"
    }

    stages {

        stage('Compile') {
            steps {
                echo 'Building WAR'
                sh 'mvn clean package'
            }
            post {
                success {
                    archiveArtifacts artifacts: '**/*.war', followSymlinks: false
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image locally'
                sh '''
                  docker build -t $LOCAL_IMAGE .
                '''
            }
        }

        stage('Trivy Scan Docker Image') {
            steps {
                echo 'Scanning image'
                sh '''
                  trivy image $LOCAL_IMAGE
                '''
            }
        }

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                      echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Tag & Push Image to Docker Hub') {
            steps {
                echo 'Tagging and pushing image to Docker Hub'
                sh '''
                  docker tag $LOCAL_IMAGE $REMOTE_IMAGE
                  docker push $REMOTE_IMAGE
                '''
            }
        }

        stage('Pull Image from Docker Hub') {
            steps {
                echo 'Pulling image from Docker Hub'
                sh '''
                  docker pull $REMOTE_IMAGE
                '''
            }
        }

        stage('Deploy to Staging') {
            steps {
                echo 'Deploying to staging environment'
                sh '''
                  docker stop myapp-staging || true
                  docker rm myapp-staging || true

                  docker run -d \
                    --name myapp-staging \
                    -p 9090:8080 \
                    $REMOTE_IMAGE
                '''
            }
        }

        stage('Deploy to Production') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    input message: 'Approve Production deployment?'
                }
                echo 'Deploying to production environment'
                sh '''
                  docker stop myapp-production || true
                  docker rm myapp-production || true

                  docker run -d \
                    --name myapp-production \
                    -p 9091:8080 \
                    $REMOTE_IMAGE
                '''
            }
        }
    }
	post { 
        always { 
            echo 'build completd, now clearing the workspace'
        }
    }
	 post {
        success{
            echo 'build successful'
        }
    }
	 post {
        failure {
            echo 'Build failed'
        }
    }
}

