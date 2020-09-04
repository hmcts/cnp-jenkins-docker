ARG version=latest

FROM hmctspublic.azurecr.io/jenkins/minimal-agent:${version}

ARG user=jenkins

USER root

# Install Prerequisites
RUN apt-get update && \
  apt-get -y install \
  docker.io \
  docker-compose && \
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
  # Install Headless Chrome
  curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
  apt-get -y update && \
  apt-get -y install \
  google-chrome-stable \
  xvfb \
  libxi6 \
  libxss1 \
  libgconf-2-4 && \
  ln -s /usr/bin/google-chrome /usr/bin/chrome && \
  mkdir /opt/nvm && \
  curl -sL -o - https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | NVM_DIR=/opt/nvm bash && \
  apt-get -y autoremove && \
  rm -rf /var/lib/apt/lists/*

USER ${user}
