pipeline {
    agent any
    
    tools {
        maven "maven-3.9" 
    }
    
    environment {
        HARBOR_URL = "10.30.20.251" 
        IMAGE_NAME = "10.30.20.251/demo/jenkins-build-app"
        TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                echo 'Building the source code...'
                sh 'mvn clean install'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    echo "Building Docker image: ${IMAGE_NAME}:${TAG}"
                    
                    // 이미지 빌드
                    def dockerImage = docker.build("${IMAGE_NAME}:${TAG}", "-f Dockerfile .")

                    // Harbor 레지스트리에 로그인 및 푸시
                    docker.withRegistry("https://${HARBOR_URL}", 'harbor-credentials') {
                        dockerImage.push()
                        dockerImage.push("latest")
                    } // withRegistry 종료
                } // script 종료 (여기가 빠졌었습니다!)
            }
        }

        stage('Update Manifest') {
            steps {
                echo 'Updating ArgoCD Manifest Repository...'
            }
        }
    }
}
