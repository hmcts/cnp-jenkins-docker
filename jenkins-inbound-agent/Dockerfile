ARG version=4.3-4-jdk11

FROM jenkins/inbound-agent:${version}

ARG user=jenkins

USER root

# Install Prerequisites
RUN apt-get update && \
  apt-get -y install \
  curl \
  git \
  unzip && \
  docker && \
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
  apt-get -y autoremove && \
  rm -rf /var/lib/apt/lists/*

RUN git clone -b v2.0.0 https://github.com/tfutils/tfenv.git /opt/tfenv && \
  ln -s /opt/tfenv/bin/* /bin && \
  chown -R ${user}:${user} /opt/tfenv

USER ${user}

RUN tfenv install 0.11.7 && \
  tfenv use 0.11.7
