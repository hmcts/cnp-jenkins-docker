#!/usr/bin/env bash

export ACR_NAME=hmctspublic
export GIT_PAT=$(az keyvault secret show --vault-name infra-vault-prod --name hmcts-github-apikey --query value -o tsv)

az acr task create \
  --registry $ACR_NAME \
  --name jenkins-agent \
  --context https://github.com/hmcts/cnp-jenkins-docker.git#master:jenkins-agent \
  --file acr-agents-build-task.yaml \
  --git-access-token $GIT_PAT \
  --subscription DCD-CNP-PROD

az acr task create \
  --registry $ACR_NAME \
  --name jenkins-jenkins \
  --image jenkins/jenkins:{{.Run.ID}} \
  --context https://github.com/hmcts/cnp-jenkins-docker.git#master:jenkins \
  --file Dockerfile \
  --git-access-token $GIT_PAT \
  --subscription DCD-CNP-PROD

