pipeline {
    agent any

    tools {
        // Install the Maven version 3.8.4 and add it to the path.
        maven 'maven384'
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                  sh("javac -version")
                  sh("newgrp docker")
                  sh("id")
                  sh("echo 'ECR REG: ${env.ECR_REGISTRY}'")
                  sh("aws ecr get-login-password --region ${env.AWS_REGION} | docker login --username AWS --password-stdin ${env.ECR_REGISTRY}")
                  sh("pip3 install pyyaml")
                }
            }
        }
        stage('Run Build Script') {
            steps {
                script {
                    git branch: "${params.branch}", url: "https://github.com/CDLUC3/merritt-docker.git"
                    sh("bin/fresh_build.sh -j '$env.WORKSPACE' -C '${params.build_config}' -m '${params.maven_profile}' -p '${params.tag_pub}' -t '${params.repo_tag}'")
                    archiveArtifacts artifacts: "build-output/**"
                    sh("cp -r build-output/artifacts/* /apps/devtools/data/jenkins/userContent/")
                }
            }
        }
    }
}
