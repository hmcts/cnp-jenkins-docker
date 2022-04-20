#!/bin/bash
set -e

dir=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)

keyvaultname=${1}

function usage() {
    echo "./bootstrap-secrets.sh <keyvaultname>"
}

if [ -z ${keyvaultname} ]; then
  usage
  exit 1
fi


function readSecret () {
    local secret_name="${1}"
    rm -f secrets/${secret_name}
    az keyvault secret download --vault-name ${keyvaultname} --name ${secret_name} --query value -o tsv -f "${dir}/../secrets/${secret_name}"
}

readSecret slack-token

readSecret mgmt-bastion-creds-password

readSecret sonarcloud-api-token
readSecret pipelinemetrics-cosmosdb-key
readSecret OWASPDb-Password
readSecret jenkins-build-logs-key

readSecret sauce-access-key

readSecret jenkins-sp-subscription-id
readSecret jenkins-sp-client-id
readSecret jenkins-sp-client-secret
readSecret jenkins-sp-tenant-id

readSecret hmcts-jenkins-cft-ghapp
readSecret hmcts-jenkins-cnp-ghapp
