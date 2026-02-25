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
    image: docker:24.0.7-dind  # dind 이미지를 사용해야 내부 설정을 바꿀 수 있습니다.
    securityContext:
      privileged: true         # dind 실행을 위해 권한 상승이 필요합니다.
    env:
    - name: DOCKER_TLS_CERTDIR
      value: ""                # TLS 미사용 설정
    command: ['dockerd-entrypoint.sh']
    args: ['--insecure-registry=10.30.20.251'] # Harbor 주소를 보안 예외로 등록
    tty: true
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
                container('maven') {
                    sh 'mvn clean install -DskipTests'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                container('docker') {
                    script {
                        // 도커 데몬이 완전히 뜰 때까지 잠시 대기
                        sh 'sleep 5' 
                        
                        echo "Logging in to Harbor: ${HARBOR_URL}"
                        // 1. Harbor 로그인
                        sh "echo ${HARBOR_CREDS_PSW} | docker login ${HARBOR_URL} -u ${HARBOR_CREDS_USR} --password-stdin"
                        
                        // 2. 이미지 빌드 및 푸시
                        sh "docker build -t ${IMAGE_NAME}:${TAG} ."
                        sh "docker push ${IMAGE_NAME}:${TAG}"
                        
                        sh "docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:latest"
                        sh "docker push ${IMAGE_NAME}:latest"
                    }
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
