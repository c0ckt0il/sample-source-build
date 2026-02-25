pipeline {
    agent any

    environment {
        // 사용할 이미지 이름 (도커 허브 등)
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
                // 예: sh './gradlew build' 또는 'npm install'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    // 도커 빌드 및 레지스트리 푸시
                    echo "Building Docker image: ${IMAGE_NAME}:${TAG}"
                    // sh "docker build -t ${IMAGE_NAME}:${TAG} ."
                    // sh "docker push ${IMAGE_NAME}:${TAG}"
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
