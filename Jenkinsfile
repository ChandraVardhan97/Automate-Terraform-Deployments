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
                sh 'terraform plan -var="public_key=$PUBLIC_KEY"'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply --auto-approve -var="public_key=$PUBLIC_KEY"'
            }
        }
    }

post {
    always {
            cleanWs()
        }
    success {
        script {
            def changes = currentBuild.changeSets.collect { cs ->
                cs.items.collect { item ->
                    "- ${item.author.fullName}: ${item.msg}"
                }.join('\n')
            }.join('\n')

            mail to: 'aspprodman@gmail.com',
                 subject: "Jenkins Pipeline Success: ${currentBuild.fullDisplayName}",
                 body: """
The Jenkins pipeline ${env.JOB_NAME} (${env.BUILD_NUMBER}) has completed successfully.

Build Details:
- Duration: ${currentBuild.durationString}
- Start Time: ${new Date(currentBuild.startTimeInMillis).format("yyyy-MM-dd HH:mm:ss")}
- End Time: ${new Date(currentBuild.timeInMillis).format("yyyy-MM-dd HH:mm:ss")}
- Triggered by: ${currentBuild.getBuildCauses()[0].shortDescription}

Changes in this build:
${changes}

Environment:
- Node: ${env.NODE_NAME}
- Workspace: ${env.WORKSPACE}

View the full log at: ${env.BUILD_URL}
"""
        }
    }
    failure {
        script {
            def failureReason = currentBuild.result == 'FAILURE' ? currentBuild.getLog(50).join('\n') : 'Unknown'
            
            mail to: 'aspprodman@gmail.com',
                 subject: "Jenkins Pipeline Failure: ${currentBuild.fullDisplayName}",
                 body: """
The Jenkins pipeline ${env.JOB_NAME} (${env.BUILD_NUMBER}) has failed.

Build Details:
- Duration: ${currentBuild.durationString}
- Start Time: ${new Date(currentBuild.startTimeInMillis).format("yyyy-MM-dd HH:mm:ss")}
- End Time: ${new Date(currentBuild.timeInMillis).format("yyyy-MM-dd HH:mm:ss")}
- Triggered by: ${currentBuild.getBuildCauses()[0].shortDescription}

Failure Reason:
${failureReason}

Environment:
- Node: ${env.NODE_NAME}
- Workspace: ${env.WORKSPACE}

View the full log at: ${env.BUILD_URL}
"""
        }
    }
}
