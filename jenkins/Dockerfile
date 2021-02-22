FROM jenkins/jenkins:2.280-jdk11

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli --latest=false -f /usr/share/jenkins/ref/plugins.txt

RUN mkdir -p /usr/share/jenkins/ref/.ssh && ssh-keyscan -t rsa github.com >> /usr/share/jenkins/ref/.ssh/known_hosts
