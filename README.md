# cnp-jenkins-docker
Jenkins docker image

## Testing locally
You need to checkout the cnp-jenkins-config and place it next to the cnp-jenkins-docker repo
i.e.
```
$ ls cnp-jenkins-
cnp-jenkins-config/  cnp-jenkins-docker/
```
Run `./bin/bootstrap-secrets.sh cftsbox-intsvc`, which will fetch the secrets required from the sandbox key vault.

Then run `docker-compose up -d`

A fully automated Jenkins image will be spun up exposed on port 8088 The credentials to login are admin/admin

The config is pulled from `cac-test-local.yml`, environment variables set in `docker-compose.yml` and organisation config in `cnp-jenkins-config/jobdsl/organisations.groovy`

## Updating Jenkins

We run Jenkins in a docker container running on Kubernetes.

All configuration is managed in cnp-flux-config, there's [common configuration](https://github.com/hmcts/cnp-flux-config/blob/master/apps/jenkins/jenkins/jenkins.yaml) and [per-instance configuration](https://github.com/hmcts/cnp-flux-config/blob/master/apps/jenkins/jenkins/ptl-intsvc/jenkins.yaml).

The Jenkins image is built from this repo, after a pull request is merged
an ACR task will automatically build and publish an image.

### Jenkins Plugins

Plugins should be automatically updated by a combination of [renovate](https://docs.renovatebot.com/modules/manager/jenkins/) and
a GitHub action running the [plugin-installation-manager-tool](https://github.com/jenkinsci/plugin-installation-manager-tool).

If you need to manually update plugins you can use:
```command
./bin/update-plugins.sh
# or without docker
./bin/update-plugins-no-docker.sh
```

Rebuild the Jenkins container `docker-compose up --build`.

Check that Jenkins starts up, you can log in, and there's no errors on the 'Manage Jenkins' page about plugins failing to load.

Create a PR with the change

### Jenkins Controller

Normally dependabot will create a PR automatically (https://github.com/hmcts/cnp-jenkins-docker/pull/42), you can approve it and it will be automatically merged.

If you need to do it manually:

Update the `FROM` statement in the [Dockerfile](https://github.com/hmcts/cnp-jenkins-docker/blob/master/jenkins/Dockerfile) to the latest version.

Follow [testing locally](#testing-locally),
check that it starts up, you can log in, and there's no errors on the 'Manage Jenkins' page about plugins failing to load.

### Promoting a new Jenkins image

Create a pull request with your change in this repo.

After the PR is merged you can monitor the [GitHub action build](https://github.com/hmcts/cnp-jenkins-docker/actions) waiting for it to complete.

You can either check the GitHub action log in the 'Build and Push step' to find the new tag or run the below script:
```shell
az acr repository show-tags -n hmctspublic --repository jenkins/jenkins --subscription DCD-CNP-PROD --orderby time_desc --query "[?\!starts_with(@, 'pr')] | [0]" -o tsv
```

Update the tag in [cnp-flux-config jenkins.yaml](https://github.com/hmcts/cnp-flux-config/blob/master/apps/jenkins/jenkins/jenkins-controller-version.yaml#L9).

Only merge the PR for prod Jenkins very early in the day, or in very quiet times, it can take ~15 minutes to startup sometimes,
likely due to the number of jobs and the number of traffic that it gets which slows down the startup.

### Renovate and Docker versioning

> ⚠️ **Note**
>
> Jenkins Docker versioning differs from the versioning used for images built
> in this repository. 
>
> We discard the compatibility suffix (for example,
> `-jdk21`) and append the sequential GitHub Actions workflow run number
> (for example, `-1186`).
>
> Therefore, a Renovate update for the controller from `2.585-jdk21` to `2.586-jdk21`
> will publish an image named `2.586-<workflow-run-number>` to the ACR to be used by Flux.
>
> This is why Renovate package rules for Jenkins controller in sds-flux-config and cnp-flux-config have custom regex.

Docker containers are not really versioned according to semantic versioning or any other strict pattern, [as Renovate's documentation points out](https://docs.renovatebot.com/modules/versioning/docker/) they are more like tags and authors have a lot of freedom in how they set these.

Jenkins controller is currently versioned in semantic-like pattern with a `compatibility suffix` instead of a `patch` which is a common convention with Docker.

Version will usually look like this: `2.585-jdk21` where the `2.x`is the major version, `x.585` is minor version and the `x.x-jdk21` is the compatibility version.

Renovate's `Docker` versioning strategy is [a default strategy when dockerfile manager is used](https://docs.renovatebot.com/modules/manager/dockerfile/#versioning) and it understands this and will not update a controller between compatibility versions such as `2.585-jdk21` and `2.586-jdk27`.

If Jenkins Docker container versioning ever changes to a different patter in the future this will need to be updated within the appropriate package rule in the [renovate.json config file](./.github/renovate.json).
