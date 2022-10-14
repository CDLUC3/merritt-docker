// @Library('merritt-build-library')
// import org.cdlib.mrt.build.BuildFunctions;

// See https://github.com/CDLUC3/mrt-jenkins/blob/main/src/org/cdlib/mrt/build/BuildFunctions.groovy

pipeline {
    //environment {      
    //}
    agent any

    tools {
        // Install the Maven version 3.8.4 and add it to the path.
        maven 'maven384'
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    sh("newgrp docker")
                    sh("id")
                    sh("echo 'ECR REG: ${env.ECR_REGISTRY}'")
                    sh("aws ecr get-login-password --region ${env.AWS_REGION} | docker login --username AWS --password-stdin ${env.ECR_REGISTRY}")
                    sh("git submodule update --remote")
                }
            }
        }
        stage('Build Java Integ Test Images') {
            steps {
                dir('mrt-inttest-services') {
                  script {
                        sh("docker-compose -f mock-merritt-it/docker-compose.yml build --pull")
                        //sh("docker-compose -f mock-merritt-it/docker-compose.yml push")
                  }
                }
            }
        }
        stage('Build End To End Test Images') {
            steps {
                dir('mrt-integ-test') {
                  script {
                        sh("docker-compose build --pull")
                        //sh("docker-compose docker-compose.yml push")
                  }
                }
            }
        }
    }
}
