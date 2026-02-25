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
    - name: DOCKER_TLS_CERTDIRhttps://github.com/c0ckt0il
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
                // 'git-credentials-id'는 Jenkins에 등록한 GitHub ID/PW(또는 Token)의 Credential ID입니다.
                withCredentials([usernamePassword(credentialsId: 'git-credentials-id', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    script {
                        echo "Updating Manifest with Tag: ${env.TAG}..."
                        
                        // 1. k8s/deployment.yaml 파일 내 이미지 태그 수정
                        // sed의 구분자를 | 로 사용하면 이미지 주소 내 / 와 충돌하지 않습니다.
                        sh "sed -i 's|10.30.20.251/demo/jenkins-build-app:.*|10.30.20.251/demo/jenkins-build-app:${env.TAG}|g' k8s/deployment.yaml"
                        
                        // 2. Git 설정 및 Push
                        // [skip ci] 또는 [ci skip]을 커밋 메시지에 넣으면 Jenkins가 다시 빌드되는 무한 루프를 방지할 수 있습니다.
                        sh """
                        git config user.email "jenkins@heybc.com"
                        git config user.name "jenkins-bot"
                        git add k8s/deployment.yaml
                        git commit -m "chore: update image tag to ${env.TAG} [skip ci]"
                        
                        # GitHub 등 원격 레포에 인증 정보 포함하여 푸시
                        # 본인의 레포 주소 형식에 맞춰 수정하세요. (현재 https 방식 기준)
                        git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/c0ckt0il/sample-source-build.git HEAD:main
                        """
                    }
                }
            }
        }
    }
}
