pipeline {
    // Run this pipeline on any available Jenkins agent
    agent any

    // Environment variables available to all stages
    environment {
        // The URL of your Artifactory registry.
        // localhost:8082 works because Jenkins will connect to Artifactory,
        // both of which are on the same Docker network.
        ARTIFACTORY_URL = 'artifactory:8081'

        // The name of the docker repository key you will create in Artifactory
        ARTIFACTORY_REPO = 'docker-dev-local'

        // The ID of the credentials you will store in Jenkins
        ARTIFACTORY_CREDENTIALS_ID = 'artifactory-creds'
    }

    stages {
        stage('Checkout') {
            steps {
                // Clones the code from the Git repository configured in the Jenkins job
                echo 'Checking out code...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                // 'dir' changes the directory for the enclosed steps
                dir('dashboard') {
                    echo 'Building the dashboard docker image...'
                    // We build the image and tag it with the Artifactory URL and the build number
                    // e.g., artifactory:8081/docker-dev-local/dashboard:3
                    script {
                        def imageName = "${env.ARTIFACTORY_URL}/${env.ARTIFACTORY_REPO}/dashboard:${env.BUILD_NUMBER}"
                        sh "docker build -t ${imageName} ."
                    }
                }
            }
        }

        stage('Push to Artifactory') {
            steps {
                dir('dashboard') {
                    echo 'Logging in to Artifactory and pushing the image...'
                    // Re-calculate the image name to use it here
                    script {
                         def imageName = "${env.ARTIFACTORY_URL}/${env.ARTIFACTORY_REPO}/dashboard:${env.BUILD_NUMBER}"

                        // Use the Jenkins credentials plugin to securely log in to Artifactory
                        withCredentials([usernamePassword(credentialsId: env.ARTIFACTORY_CREDENTIALS_ID, passwordVariable: 'ARTIFACTORY_PASSWORD', usernameVariable: 'ARTIFACTORY_USER')]) {
                            sh "docker login ${env.ARTIFACTORY_URL} -u ${ARTIFACTORY_USER} -p ${ARTIFACTORY_PASSWORD}"
                            sh "docker push ${imageName}"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            // This runs after the pipeline finishes, regardless of success or failure
            echo 'Pipeline finished. Cleaning up...'
            // Clean up the Docker image from the Jenkins agent to save space
            script {
                def imageName = "${env.ARTIFACTORY_URL}/${env.ARTIFACTORY_REPO}/dashboard:${env.BUILD_NUMBER}"
                sh "docker rmi ${imageName} || true"
            }
        }
    }
}