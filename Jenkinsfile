pipeline {
    agent any

    environment {
        IMAGE_NAME = "urx95/node-mongo-app"
        VERSION = "v${BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID = "docker-hub-creds"
    }

    stages {
        stage('Checkout Repo') {
            steps {
                git url: 'https://github.com/urxismrx/node-mongo-app.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🔨 Building Docker image with tag $VERSION..."
                sh '''
                    docker build -t $IMAGE_NAME:$VERSION .
                    docker tag $IMAGE_NAME:$VERSION $IMAGE_NAME:latest
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "📦 Pushing image to Docker Hub..."
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME:$VERSION
                        docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "🚀 Deploying image $VERSION to Kubernetes..."
                sh '''
                    sed "s|urx95/node-mongo-app:.*|urx95/node-mongo-app:$VERSION|" k8s/node-deployment.yaml | kubectl apply -f -
                    kubectl apply -f k8s/mongo-deployment.yaml
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment complete!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
