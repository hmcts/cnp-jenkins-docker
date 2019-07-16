# cnp-jenkins-di
Jenkins docker image source file

## To create again the ACR task

export ACR_NAME=hmctspublic
export GIT_PAT=<GitHub token>

az acr task create \
    --registry $ACR_NAME \
    --name jenkins \
    --image jenkins:{{.Run.ID}} \
    --context https://github.com/hmcts/cnp-jenkins-di.git \
    --branch master \
    --file Dockerfile \
    --git-access-token $GIT_PAT 