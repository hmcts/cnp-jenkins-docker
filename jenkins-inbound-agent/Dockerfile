ARG version=4.3-4-jdk11

FROM jenkins/inbound-agent:${version}

ARG user=jenkins

USER root

# Install Prerequisites
RUN apt-get update && \
  apt-get -y install \
  curl \
  git \
  unzip \
  docker.io && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  apt-get update && \
  # Install Node
  apt-get -y install \
  nodejs \
  build-essential \
  yarn \
  && \
  # Install Azure CLI
  curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
  # Install Headless Chrome
  curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
  apt-get -y update && \
  apt-get -y install \
  google-chrome-stable \
  xvfb \
  libxi6 \
  libgconf-2-4 && \
  ln -s /usr/bin/google-chrome /usr/bin/chrome && \
  curl -sL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl && \
  curl -sL -o - https://get.helm.sh/helm-v3.1.2-linux-amd64.tar.gz | tar xz && \
  mv /linux-amd64/helm /usr/local/bin/helm && \
  rm -rf /linux-amd64  && \
  chmod +x /usr/local/bin/kubectl && \
  apt-get -y autoremove && \
  rm -rf /var/lib/apt/lists/*

RUN git clone -b v2.0.0 https://github.com/tfutils/tfenv.git /opt/tfenv && \
  ln -s /opt/tfenv/bin/* /bin && \
  chown -R ${user}:${user} /opt/tfenv

RUN mkdir -p /usr/share/jenkins/ref/.ssh && \
  ssh-keyscan -t rsa github.com >> /usr/share/jenkins/ref/.ssh/known_hosts && \
  chown -R ${user}:${user} /usr/share/jenkins/ref/.ssh  && \
  chmod 700 /usr/share/jenkins/ref/.ssh && \  
  chmod 644 /usr/share/jenkins/ref/.ssh/known_hosts  

USER ${user}

RUN tfenv install 0.11.7 && \
  tfenv use 0.11.7
