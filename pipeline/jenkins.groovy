pipeline {
  agent any
  parameters {
    choice(name: 'OS', choices: ['linux', 'windows', 'darwin'], description: 'Choose the operating system')
    choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Choose the architecture')
  }
  environment {
    OS = "${params.OS}"
    ARCH = "${params.ARCH}"
  }
  stages {
    stage('Clone') {
      steps {
        git branch: 'main', url: 'https://github.com/Mardukay/kbot'
      }
    }
    stage('Test') {
      steps {
        echo "Test stage"
        sh 'make test'
      }
    }
    stage('Build') {
      steps {
        script {
          // Check if OS is windows
          if (params.OS == "windows") {
            echo "Build for platform ${params.OS}"
            echo "Build for arch: ${params.ARCH}"
            sh 'make image OS=windows ARCH=$ARCH EXT=.exe'
          } else {
            echo "Build for platform ${params.OS}"
            echo "Build for arch: ${params.ARCH}"
            sh 'make image OS=$OS ARCH=$ARCH'
          }
        }
      }
    }
    stage('Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh 'docker login -u $USERNAME -p $PASSWORD'
          sh 'make push'
        }
      }
    }
  }
}
