# TODO remove plugin cli override when updating this version
FROM jenkins/jenkins:2.309-jdk11

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# TODO remove once https://github.com/jenkinsci/docker/pull/1192 is merged and release
# should be in 2.309
ARG PLUGIN_CLI_VERSION=2.10.2
ARG PLUGIN_CLI_URL=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/${PLUGIN_CLI_VERSION}/jenkins-plugin-manager-${PLUGIN_CLI_VERSION}.jar
USER root
RUN curl -fsSL ${PLUGIN_CLI_URL} -o /opt/jenkins-plugin-manager.jar
USER jenkins

RUN jenkins-plugin-cli --latest=false -f /usr/share/jenkins/ref/plugins.txt

RUN mkdir -p /usr/share/jenkins/ref/.ssh && \
    ssh-keyscan -t rsa github.com >> /usr/share/jenkins/ref/.ssh/known_hosts && \
    mkdir -p /usr/share/jenkins/ref/logs && \
    touch /usr/share/jenkins/ref/logs/.keep
