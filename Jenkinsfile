pipeline {
    agent any

    stages {
        stage('compile') {
            steps {
                echo 'Hello World'
 		sh 'mvn clean package'
            }
        }

        stage('unitest') {
            steps {
                echo 'Hello'
            }
        }
    }
}

