pipeline {
    agent any
 
    parameters {
        choice(name: 'ACTION', choices: ['plan','apply','destroy'], description: 'Acción de Terraform')
    }
 
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-sa-key')
        PROJECT_ID = "jenkins-terraform-demo-472920"
    }
 
    stages {
        stage('Init') {
            steps {
                sh 'terraform init -input=false'
            }
        }
        stage('Terraform Action') {
            steps {
                script {
                  def auto = (params.ACTION in ['apply','destroy']) ? '-auto-approve' : ''
                  sh """
                    terraform ${params.ACTION} ${auto} -input=false \
                      -var="project=${PROJECT_ID}" \
                      -var="credentials_file=${GOOGLE_APPLICATION_CREDENTIALS}"
                  """
                }
            }
        }
    }
 
    post {
        success {
            echo "PostgreSQL ${params.ACTION} completado correctamente"
        }
        failure {
            echo "Error en Terraform"
        }
    }
}
