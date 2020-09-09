FROM jenkins/jenkins:2.256-jdk11

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

USER root
RUN wget -q https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/plugin-management-parent-pom-2.0.0/jenkins-plugin-manager-2.0.0.jar -O /usr/local/lib/jenkins-plugin-manager.jar
USER jenkins

RUN java -jar /usr/local/lib/jenkins-plugin-manager.jar -f /usr/share/jenkins/ref/plugins.txt

RUN mkdir -p /usr/share/jenkins/ref/.ssh && ssh-keyscan -t rsa github.com >> /usr/share/jenkins/ref/.ssh/known_hosts
