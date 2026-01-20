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
                echo 'scanning docker image'
                sh 'trivy image myregistry.local/myapp:"$BUILD_NUMBER" '
            }
        }
    }
}

