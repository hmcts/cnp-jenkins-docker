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

Run `acr_task_creation.sh`, which will create the required tasks to automatically re-build the images when you merge a commit to the master branch.
