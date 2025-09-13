pipeline {
    agent {
        docker {
            image 'maven:3.9-eclipse-temurin-17'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/rklorD456/spring-petclinic.git'
            }
        }
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("spring-petclinic:latest")
                }
            }
        }
        stage('Run Container') {
            steps {
                sh 'docker run -d --rm --name petclinic -p 8081:8080 spring-petclinic:latest'
            }
        }
    }
    post {
        always {
            sh 'docker ps -a'
        }
        cleanup {
            sh 'docker stop petclinic || true'
        }
    }
}
