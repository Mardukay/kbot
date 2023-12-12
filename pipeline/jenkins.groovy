pipeline {
  agent any
  parameters {
    choice(name: 'OS', choices: ['linux', 'windows', 'darwin'], description: 'Choose the operating system')
    choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Choose the architecture')
  }
  environment {
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
          when {
            expression { params.OS == 'windows' }
          }
          // Execute make with windows arguments
          echo "Build for platform ${params.OS}"
          echo "Build for arch: ${params.ARCH}"
          sh 'make image OS=windows ARCH=$ARCH EXT=.exe'
          // Check if OS is linux
          when {
            expression { params.OS == 'linux' }
          }
          // Execute make with linux arguments
          echo "Build for platform ${params.OS}"
          echo "Build for arch: ${params.ARCH}"
          sh 'make image OS=linux ARCH=$ARCH'
          // Check if OS is darwin
          when {
            expression { params.OS == 'darwin' }
          }
          // Execute make with darwin arguments
          echo "Build for platform ${params.OS}"
          echo "Build for arch: ${params.ARCH}"
          sh 'make image OS=darwin ARCH=$ARCH'
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
