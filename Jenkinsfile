#!/bin/groovy

node('master'){
    stage('Setup') {
        def success = false
        try {
            cleanWs()
            notifySlack()
            checkout scm
            if (env.BRANCH_NAME.contains('/') || env.BRANCH_NAME.contains('_')){
                branchNameCORE = env.BRANCH_NAME.replace("/", "-").replace("_", "-")
            } else {
                branchNameCORE = env.BRANCH_NAME
            }
            success = true
        } catch (e) {
            currentBuild.result = 'FAILURE'
            throw e
        } finally {
            if (!success)
                notifySlack(currentBuild.result)
        }
    }

    stage('Build Image') {
        def success = false
        try {
            docker.build("wacken/workshop:aspnet-${branchNameCORE}-${env.BUILD_NUMBER}")
            success = true
        } catch (e) {
            currentBuild.result = 'FAILURE'
            throw e
        } finally {
            if (!success)
                notifySlack(currentBuild.result)
        }
    }

    stage('Push Image') {
        def success = false
        try {
            withDockerRegistry(credentialsId: 'a045a5e3-46af-4eb6-a9c6-27bc116f3ffd', url: '') {
                docker.image("wacken/workshop:aspnet-${branchNameCORE}-${env.BUILD_NUMBER}").push()
            }
            success = true
        } catch (e) {
            currentBuild.result = 'FAILURE'
            throw e
        } finally {
            if (!success)
                notifySlack(currentBuild.result)
        }
    }

    stage('Init deploy') {
            build 'deploy/start-prod'
    }
}

def notifySlack(String buildStatus = 'STARTED') {
    // Build status of null means success.
    buildStatus = buildStatus ?: 'SUCCESS'

    def color

    if (buildStatus == 'STARTED') {
        color = '#D4DADF'
    } else if (buildStatus == 'SUCCESS') {
        color = '#BDFFC3'
    } else if (buildStatus == 'UNSTABLE') {
        color = '#FFFE89'
    } else {
        color = '#FF9FA1'
    }

    def msg = "${buildStatus}: `${env.JOB_NAME}` #${env.BUILD_NUMBER}:\n${env.BUILD_URL}"

    slackSend(color: color, message: msg)
}