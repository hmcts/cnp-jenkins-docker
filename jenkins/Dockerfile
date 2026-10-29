FROM maven:3.10-eclipse-temurin-21 AS sauce-ondemand

ADD https://github.com/jenkinsci/sauce-ondemand-plugin.git#a862c70abd6f98e544dcabbfcca47000911cc7d8 /src

WORKDIR /src

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN grep -rl 'org.apache.commons.lang.StringUtils' src/main/java | \
    xargs sed -i 's/org\.apache\.commons\.lang\.StringUtils/org.apache.commons.lang3.StringUtils/' && \
    mvn -B -ntp -Dquick-build -DskipTests -Dchangelist=-hmcts-1 package

FROM jenkins/jenkins:2.588-jdk21

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

COPY --from=sauce-ondemand /src/target/sauce-ondemand.hpi /usr/share/jenkins/ref/plugins/sauce-ondemand.jpi

RUN mkdir -p /usr/share/jenkins/ref/.ssh && \
    ssh-keyscan -t rsa github.com >> /usr/share/jenkins/ref/.ssh/known_hosts && \
    mkdir -p /usr/share/jenkins/ref/logs && \
    touch /usr/share/jenkins/ref/logs/.keep
