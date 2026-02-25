pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: maven
    image: maven:3.9-eclipse-temurin-17
    command: ['cat']
    tty: true
  - name: docker
    image: docker:24.0.7  # 도커 명령어가 포함된 이미지
    command: ['cat']
    tty: true
    volumeMounts:
    - name: dockersock
      mountPath: /var/run/docker.sock
  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock
"""
        }
    }
    
    tools {
        maven "maven-3.9" 
    }
    
    environment {
        HARBOR_URL = "10.30.20.251" 
        IMAGE_NAME = "10.30.20.251/demo/jenkins-build-app"
        TAG = "${env.BUILD_NUMBER}"
        // Harbor 자격 증명을 변수로 가져옵니다. 
        // 젠킨스 Credentials ID가 'harbor-credentials'여야 합니다.
        HARBOR_CREDS = credentials('harbor-credentials')
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
                // docker 컨테이너 안에서 실행하도록 감싸줍니다.
                container('docker') {
                    echo "Building Docker image: ${IMAGE_NAME}:${TAG}"
                    
                    // 1. Harbor 로그인
                    sh "echo ${HARBOR_CREDS_PSW} | docker login ${HARBOR_URL} -u ${HARBOR_CREDS_USR} --password-stdin"
                    
                    // 2. 이미지 빌드 및 푸시
                    sh "docker build -t ${IMAGE_NAME}:${TAG} ."
                    sh "docker push ${IMAGE_NAME}:${TAG}"
                    sh "docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:latest"
                    sh "docker push ${IMAGE_NAME}:latest"
                    
                    sh "docker logout ${HARBOR_URL}"
                }
            }
        }
        
        stage('Update Manifest') {
            steps {
                echo 'Updating ArgoCD Manifest Repository...'
            }
        }
    }
}
