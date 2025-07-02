pipeline {
    agent any

    environment {
        IMAGE_NAME = "urxismrx/node-mongo-app"
        DOCKER_CREDENTIALS_ID = "docker-hub-creds"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                dir('/home/urx/final-task') {
                    sh 'docker build -t $IMAGE_NAME .'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Docker image built and pushed!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs.'
        }
    }
}

