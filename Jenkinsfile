pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('rudechump-dockerhub')
  }
  
  stages {
    stage('Test') {
      steps {
            sh 'echo test' 
        script {
          try {
             def TEST = sh(returnStdout: true, script: "mvn test1")
             print TEST
          }
          catch (e) {
            print e
          }
        }
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
               }
           }
    }
    stage('Build') {
      steps {
        sh 'docker build -t rudechump/dp-alpine:latest .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push rudechump/dp-alpine:latest'
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}