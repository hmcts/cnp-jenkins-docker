FROM jenkins/jenkins:2.250-jdk11

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

USER root
RUN wget -q https://github.com/timja/plugin-installation-manager-tool/releases/download/plugin-management-parent-pom-1.2.4-beta/jenkins-plugin-manager-1.2.1-SNAPSHOT.jar -O /usr/local/lib/jenkins-plugin-manager.jar
USER jenkins

ENV JENKINS_UC https://updates.jenkins.io/update-center.actual.json
ENV JENKINS_UC_EXPERIMENTAL https://updates.jenkins.io/experimental/update-center.actual.json
RUN java -jar /usr/local/lib/jenkins-plugin-manager.jar -f /usr/share/jenkins/ref/plugins.txt

RUN mkdir -p /usr/share/jenkins/ref/.ssh && ssh-keyscan -t rsa github.com >> /usr/share/jenkins/ref/.ssh/known_hosts
