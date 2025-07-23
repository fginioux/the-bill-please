pipeline {
    agent any

    triggers {
        githubPush()
    }

    stages {
        stage('Test DB Connection') {
            steps {
                sh '''
                PGPASSWORD=postgres psql -h localhost -U postgres -d postgres -c "\\conninfo"
                '''
            }
        }

        stage('Checkout') {
            steps {
                withCredentials([string(credentialsId: "GITHUB_TOKEN_CRED_ID", variable: 'GITHUB_TOKEN')]) {
                    sh 'git config --global credential.helper store'
                    sh 'echo "https://${GITHUB_TOKEN}:@github.com" > ~/.git-credentials'
                    git url: "${GITHUB_URL}", branch: 'main'
                }
            }
        }

        stage('Build') {
            steps {
                sh 'MAVEN_OPTS="-Xmx512m" mvn clean package -T 1C -Dmaven.compiler.fork=true'
                sh 'mvn clean package'
            }
        }

        stage('Prepare Deployment') {
            steps {
                writeFile file: 'deploy.sh', text: '''#!/bin/bash
cd /home/ubuntu/
docker compose down || true
docker compose up -d
'''
                sh 'chmod +x deploy.sh'
            }
        }

        stage('Transfer Files') {
            steps {
                script {
                    withCredentials([string(credentialsId: "SERVER_IP_CRED_ID", variable: 'SERVER_IP')]) {
                        sshagent(credentials: ['aws-ec2']) {
                            sh '''
                            ssh -o StrictHostKeyChecking=no ubuntu@$SERVER_IP "mkdir -p /home/ubuntu/target"
                            scp -o StrictHostKeyChecking=no target/store-0.0.1-SNAPSHOT.jar ubuntu@$SERVER_IP:/home/ubuntu/target/
                            scp -o StrictHostKeyChecking=no docker-compose.yml ubuntu@$SERVER_IP:/home/ubuntu/
                            scp -o StrictHostKeyChecking=no Dockerfile ubuntu@$SERVER_IP:/home/ubuntu
                            scp -o StrictHostKeyChecking=no deploy.sh ubuntu@$SERVER_IP:/home/ubuntu/
                            '''
                        }
                    }
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    withCredentials([string(credentialsId: "SERVER_IP_CRED_ID", variable: 'SERVER_IP')]) {
                        sshagent(credentials: ['aws-ec2']) {
                            sh '''
                            ssh -o StrictHostKeyChecking=no ubuntu@$SERVER_IP "/home/ubuntu/deploy.sh"
                            '''
                            sh '''
                            sleep 30
                            url="http://$SERVER_IP:8081/swagger-ui/index.html"
                            response=$(curl -s -o /dev/null -w "%{http_code}" $url)
                            echo "Response code: $response"
                            if [ "$response" -eq 200 ]; then
                                echo "Visit to $url was successful"
                            else
                                echo "Visit to $url failed with status code: $response"
                                exit 1
                            fi
                            '''
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
