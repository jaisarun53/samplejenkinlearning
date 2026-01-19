pipeline {
    agent any

    stages {
        stage('compile') {
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

        stage('unitest') {
            steps {
                echo 'Hello'
            }
        }
    }
}

