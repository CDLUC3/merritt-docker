// @Library('merritt-build-library')
// import org.cdlib.mrt.build.BuildFunctions;

// See https://github.com/CDLUC3/mrt-jenkins/blob/main/src/org/cdlib/mrt/build/BuildFunctions.groovy

pipeline {
    environment {
        ECRPUSH = true
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
                        sh("docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/dep-cdlmvn:dev dep_cdlmvn")
                        if (env.ECRPUSH == 'true') {
                            sh("docker push ${ECR_REGISTRY}/dep-cdlmvn:dev")
                        }

                        sh("docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-core2:dev dep_core")
                        if (env.ECRPUSH == 'true') {
                            sh("docker push ${ECR_REGISTRY}/mrt-core2:dev")
                        }

                        sh("docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/cdl-zk-queue:dev dep_cdlzk")
                        if (env.ECRPUSH == 'true') {
                            sh("docker push ${ECR_REGISTRY}/cdl-zk-queue:dev")
                        }

                        sh("docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-zoo:dev dep_zoo")
                        if (env.ECRPUSH == 'true') {
                            sh("docker push ${ECR_REGISTRY}/mrt-zoo:dev")
                        }

                        sh("docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-cloud:dev dep_cloud")
                        if (env.ECRPUSH == 'true') {
                            sh("docker push ${ECR_REGISTRY}/mrt-cloud:dev")
                        }

                        sh("docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory-src:dev inventory")
                        if (env.ECRPUSH == 'true') {
                            sh("docker push ${ECR_REGISTRY}/mrt-inventory-src:dev")
                        }
                  }
                }
            }
        }
         stage('Build Services Stack') {
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
    }
}
