ARG version=4.3-4-jdk11

FROM jenkins/inbound-agent:${version}

ARG user=jenkins

USER root

# Install Prerequisites
RUN apt-get update && \
  apt-get -y install \
  curl \
  git \
  # Install Node
  nodejs \
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
  unzip \
  xvfb \
  libxi6 \
  libgconf-2-4 && \
  chrome=$(curl https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
  curl https://chromedriver.storage.googleapis.com/$chrome/chromedriver_linux64.zip --output chromedriver_linux64.zip && \
  unzip chromedriver_linux64.zip && \
  mv chromedriver /usr/bin/chromedriver && \
  chown root:root /usr/bin/chromedriver && \
  chmod +x /usr/bin/chromedriver && \
  curl https://selenium-release.storage.googleapis.com/3.13/selenium-server-standalone-3.13.0.jar --output selenium-server-standalone.jar && \
  curl http://www.java2s.com/Code/JarDownload/testng/testng-6.8.7.jar.zip --output testng-6.8.7.jar.zip && \
  unzip testng-6.8.7.jar.zip && \
  rm \
  testng-6.8.7.jar.zip \
  chromedriver_linux64.zip && \
  apt-get -y remove --purge unzip && \
  apt-get -y autoremove && \
  rm -rf /var/lib/apt/lists/*

USER ${user}

# Install tfenv
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
  echo 'PATH=${HOME}/.tfenv/bin:${PATH}' >> ~/.bashrc && \
  . ~/.bashrc

USER root

ENTRYPOINT ["/bin/bash"]
