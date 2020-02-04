# cnp-jenkins-docker
Jenkins docker image

## Testing locally
You need to checkout the cnp-jenkins-config and place it next to the cnp-jenkins-docker repo
i.e.
```
$ ls cnp-jenkins-
cnp-jenkins-config/  cnp-jenkins-docker/
```
Run `./bootstrap-secrets.sh cftsbox-intsvc`, which will fetch the secrets required from the sandbox key vault.

Then run `docker-compose up -d`

A fully automated Jenkins image will be spun up exposed on port 8088 The credentials to login are admin/admin

The config is pulled from `cac-test-local.yml`, environment variables set in `docker-compose.yml` and organisation config in `cnp-jenkins-config/jobdsl/organisations.groovy`


## To create the ACR task

```bash
export ACR_NAME=hmctspublic
export GIT_PAT=$(az keyvault secret show --vault-name infra-vault-prod --name hmcts-github-apikey --query value -o tsv)

az acr task create \
    --registry $ACR_NAME \
    --name jenkins \
    --image jenkins:{{.Run.ID}} \
    --context https://github.com/hmcts/cnp-jenkins-docker.git \
    --branch master \
    --file Dockerfile \
    --git-access-token $GIT_PAT \
    --subscription DCD-CNP-PROD
```
