pipeline {
    agent any
    tools {
        maven 'M3'
    }
    
    environment {
        // Make sure Jenkins can find docker binary
        PATH = "/usr/bin:${env.PATH}"
        DOCKER_IMAGE = "spring-petclinic:latest"
        CONTAINER_NAME = "petclinic"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                echo "Building the project with Maven..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Verify Docker') {
            steps {
                echo "Checking Docker installation inside Jenkins..."
                sh 'which docker'
                sh 'docker --version'
                sh 'docker info'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image ${DOCKER_IMAGE}..."
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Run Container') {
            steps {
                echo "Stopping and removing old container if exists..."
                sh """
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                """
                echo "Running new container..."
                sh "docker run -d --name ${CONTAINER_NAME} -p 8080:8080 ${DOCKER_IMAGE}"
            }
        }
    }

    post {
        always {
            echo "Pipeline finished (success or failure)."
        }
        success {
            echo "Application deployed successfully on http://localhost:8080"
            sh "docker ps | grep ${CONTAINER_NAME} || true"
        }
        failure {
            echo "Pipeline failed. Check logs above for details."
        }
    }
}
