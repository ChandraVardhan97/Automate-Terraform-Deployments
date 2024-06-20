pipeline {
    agent any
  triggers {
        githubPush()
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('c4b408ff-65e8-4b24-9d7f-9091ddb505fb')
        AWS_SECRET_ACCESS_KEY = credentials('c4b408ff-65e8-4b24-9d7f-9091ddb505fb')
        PUBLIC_KEY            = credentials('mykey_pub')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/ChandraVardhan97/Automate-Terraform-Deployments.git', credentialsId: 'github-pat'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -backend-config="bucket=kkloud1234" -backend-config="key=global/mystatefile/terraform.tfstate" -backend-config="region=us-east-1"'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            mail to: 'aspprodman@gmail.com',
                 subject: "Jenkins Pipeline Success: ${currentBuild.fullDisplayName}",
                 body: "The Jenkins pipeline ${env.JOB_NAME} (${env.BUILD_NUMBER}) has completed successfully. \n\nView the log at: ${env.BUILD_URL}"
        }
        failure {
            mail to: 'aspprodman@gmail.com',
                 subject: "Jenkins Pipeline Failure: ${currentBuild.fullDisplayName}",
                 body: "The Jenkins pipeline ${env.JOB_NAME} (${env.BUILD_NUMBER}) has failed. \n\nView the log at: ${env.BUILD_URL}"
        }
    }
}
