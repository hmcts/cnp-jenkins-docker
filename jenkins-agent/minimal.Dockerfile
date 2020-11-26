ARG version=4.6-1-jdk11

FROM jenkins/inbound-agent:${version}

ARG user=jenkins

USER root

# Install Prerequisites
RUN apt-get update && \
  apt-get -y install \
  curl \
  git \
  unzip \
  rsync \
  && \
  # Install Azure CLI
  curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
  curl -sL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl && \
  chmod +x /usr/local/bin/kubectl && \
  curl -sL -o - https://get.helm.sh/helm-v3.1.2-linux-amd64.tar.gz | tar xz && \
  mv ./linux-amd64/helm /usr/local/bin/helm && \
  rm -rf ./linux-amd64  && \
  curl -sL -o /tini https://github.com/krallin/tini/releases/download/v0.19.0/tini && \
  chmod +x /tini && \
  cd /bin && \
  rm -f sh && \
  ln -s bash sh && \
  apt-get -y autoremove && \
  rm -rf /var/lib/apt/lists/*

RUN git clone -b v2.0.0 https://github.com/tfutils/tfenv.git /opt/tfenv && \
  ln -s /opt/tfenv/bin/* /bin && \
  chown -R ${user}:${user} /opt/tfenv

RUN mkdir -p /home/jenkins/.ssh && \
  ssh-keyscan -t rsa github.com >> /home/jenkins/.ssh/known_hosts && \
  chown -R ${user}:${user} /home/jenkins/.ssh  && \
  chmod 700 /home/jenkins/.ssh && \  
  chmod 644 /home/jenkins/.ssh/known_hosts  

USER ${user}

RUN tfenv install 0.11.7 && \
  tfenv use 0.11.7

