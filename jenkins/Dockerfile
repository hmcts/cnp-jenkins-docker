FROM jenkins/jenkins:2.435-jdk11

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

RUN mkdir -p /usr/share/jenkins/ref/.ssh && \
    ssh-keyscan -t rsa github.com >> /usr/share/jenkins/ref/.ssh/known_hosts && \
    mkdir -p /usr/share/jenkins/ref/logs && \
    touch /usr/share/jenkins/ref/logs/.keep
