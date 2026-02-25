pipeline {
    agent any
    
    tools {
        maven "maven-3.9" 
    }
    
    environment {
        // 사용할 이미지 이름 (도커 허브 등)
        HARBOR_URL = "10.30.20.251" 
        IMAGE_NAME = "10.30.20.251/demo/jenkins-build-app"
        TAG = "${env.BUILD_NUMBER}"
        
        IMAGE_NAME = "c0ckt0il/sample-app"
        TAG = "${env.BUILD_NUMBER}" // 빌드 번호를 태그로 사용
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
                // 예: sh './gradlew build' 또는 'npm install'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    // 도커 빌드 및 레지스트리 푸시
                    echo "Building Docker image: ${IMAGE_NAME}:${TAG}"
                    
                    // 이미지 빌드
                    dockerImage = docker.build("${IMAGE_NAME}:${TAG}", "-f Dockerfile .")

                    // 2. Harbor 레지스트리에 로그인 및 푸시
                    // 여기서 'harbor-credentials'는 젠킨스에 등록한 Credential ID입니다.
                    docker.withRegistry("https://${HARBOR_URL}", 'harbor-credentials') {
                        dockerImage.push()
                        dockerImage.push("latest")
                }
            }
        }

        stage('Update Manifest') {
            steps {
                echo 'Updating ArgoCD Manifest Repository...'
                // ArgoCD가 바라보는 Git Repo의 YAML 파일 안의 이미지 태그를 
                // 위에서 만든 ${TAG}로 수정하는 스크립트를 여기에 작성합니다.
            }
        }
    }
}
