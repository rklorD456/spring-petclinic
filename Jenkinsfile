pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "spring-petclinic:latest"
    }

    tools {
        maven 'M3' // Make sure Maven is installed under Jenkins global tools
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                echo 'Building the project with Maven...'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Verify Docker') {
            steps {
                echo 'Checking Docker availability...'
                sh 'docker --version && docker info'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image ${DOCKER_IMAGE}..."
                sh '''
                  cp target/spring-petclinic-*.jar .
                  docker build -t ${DOCKER_IMAGE} .
                '''
            }
        }

        stage('Start Database (Optional)') {
            steps {
                echo 'Starting database using docker compose...'
                sh 'docker compose up -d mysql'
            }
        }

        stage('Run Container') {
            steps {
                echo 'Running Spring Petclinic container...'
                sh '''
                  docker rm -f petclinic || true
                  docker run -d --name petclinic -p 8080:8080 spring-petclinic:latest
                  docker ps
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline finished (success or failure)."
        }
        failure {
            echo "Pipeline failed. Check logs above for details."
        }
    }
}
