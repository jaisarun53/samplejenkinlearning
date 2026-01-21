pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "arunjaiswal53"
        IMAGE_NAME = "myapp"
        IMAGE_TAG = "${BUILD_NUMBER}"
        CONTAINER_NAME = "myapp"
        TOMCAT_PORT = "8082"
        HOST_PORT = "8071"
    }

    stages {

        stage('Build WAR') {
            steps {
                echo 'Building the WAR file using Maven'
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
                echo 'Building Docker image from Dockerfile'
                sh """
                   docker build -t $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG .
                """
            }
        }

        stage('Trivy Scan Docker Image') {
            steps {
                echo 'Scanning Docker image for vulnerabilities'
                sh """
                   trivy image $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG
                """
            }
        }

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                echo 'Pushing Docker image to Docker Hub'
                sh """
                   docker push $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG
                """
            }
        }

        stage('Pull Image for Deployment') {
            steps {
                echo 'Pulling the Docker image from Docker Hub'
                sh """
                   docker pull $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG
                """
            }
        }

        stage('Deploy Container') {
            steps {
                echo 'Deploying Tomcat container with WAR'
                sh """
                   # Stop and remove old container if it exists
                   docker rm -f $CONTAINER_NAME || true

                   # Run new container
                   docker run -d \
                     --name $CONTAINER_NAME \
                     -p $HOST_PORT:$TOMCAT_PORT \
                     $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG
                """
            }
        }
    }
}

