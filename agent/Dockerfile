FROM jenkins/inbound-agent:latest

USER root

# add tini to manage zombie/defunct processes since java process has pid=1
# if using "docker run" you can use the "--init" parameter which uses tini directly
ENV TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ARG DOCKER_GID=999

# Create docker group with host's GID BEFORE installing Docker packages
# This ensures the installed packages use our group instead of creating their own
RUN groupadd -g ${DOCKER_GID} docker

RUN curl -fsSL "https://get.docker.com/" | sh

COPY provision.sh /provision.sh

RUN chmod +x /provision.sh

RUN /provision.sh

RUN usermod -aG docker jenkins

RUN groupadd -g 118 supplemental && usermod -aG 118 jenkins

RUN mkdir -p /var/lib/docker

VOLUME [/var/lib/docker]

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["sh", "/entrypoint.sh"]