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
    image: docker:24.0.7-dind
    securityContext:
      privileged: true
    env:
    - name: DOCKER_TLS_CERTDIR
      value: ""
    command: ['dockerd-entrypoint.sh']
    args: ['--insecure-registry=10.30.20.251']
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
        HARBOR_CREDS = credentials('harbor-credentials')
        // TAG는 script 블록 내에서 동적으로 생성하여 재할당할 예정입니다.
    }

    stages {
        stage('Prepare Tag') {
            steps {
                script {
                    // 현재 시간을 YYYYMMDD-HHmmSS 포맷으로 생성
                    def now = new Date()
                    env.TAG = now.format("yyyyMMdd-HHmmss", TimeZone.getTimeZone('Asia/Seoul'))
                    echo "Generated Tag: ${env.TAG}"
                }
            }
        }

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
                        sh 'sleep 5' 
                        
                        echo "Logging in to Harbor: ${HARBOR_URL}"
                        sh "echo ${HARBOR_CREDS_PSW} | docker login ${HARBOR_URL} -u ${HARBOR_CREDS_USR} --password-stdin"
                        
                        echo "Building and Pushing image with tag: ${env.TAG}"
                        
                        // 이미지 빌드 및 푸시
                        sh "docker build -t ${IMAGE_NAME}:${env.TAG} ."
                        sh "docker push ${IMAGE_NAME}:${env.TAG}"
                    }
                }
            }
        }

        stage('Update Manifest') {
            steps {
                script {
                    echo "Updating ArgoCD Manifest with Tag: ${env.TAG}..."
                    // 여기서 ArgoCD가 보는 Git Repo의 YAML 내 태그를 ${env.TAG}로 업데이트하면 됩니다.
                }
            }
        }
    }
}
