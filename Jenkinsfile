// @Library('merritt-build-library')
// import org.cdlib.mrt.build.BuildFunctions;

// See https://github.com/CDLUC3/mrt-jenkins/blob/main/src/org/cdlib/mrt/build/BuildFunctions.groovy

pipeline {
    environment {
        ECRPUSH = false
    }
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
        stage('Submodules Init') {
            steps {
                script {
                    sh("sed -e \"s%git@github.com:%https://github.com/%\" -i .gitmodules")
                    sh("git submodule init")
                    sh("git submodule update --remote")
                }
            }
        }
        stage('Build Java Integ Test Images') {
            steps {
                dir('mrt-inttest-services') {
                  script {
                        sh("docker-compose -f mock-merritt-it/docker-compose.yml build --pull")
                        if (env.ECRPUSH == 'true') {
                            sh("docker-compose -f mock-merritt-it/docker-compose.yml push")
                        }
                  }
                }
            }
        }
        stage('Build End To End Test Images') {
            steps {
                dir('mrt-integ-tests') {
                  script {
                        sh("docker-compose build --pull")
                        if (env.ECRPUSH == 'true') {
                            sh("docker-compose push")
                        }
                  }
                }
            }
        }
        stage('Build Library Images') {
            steps {
                dir('mrt-services') {
                  script {
                        sh("docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-core2:dev dep_core")
                        if (env.ECRPUSH == 'true') {
                            sh("docker push ${ECR_REGISTRY}/mrt-core2:dev")
                        }
                  }
                }
            }
        }
        /*
        stage('Build Services') {
            steps {
                dir('mrt-services') {
                  script {
                        sh("docker-compose build --pull")
                        if (env.ECRPUSH == 'true') {
                            sh("docker-compose push")
                        }
                  }
                }
            }
        }
        */
    }
}
