FROM node:latest

ENV PARSE_HOME /parse

RUN apt-get update && \
    apt-get install -y --no-install-recommends git openssh-server && \
    git clone https://github.com/ParsePlatform/parse-server.git $PARSE_HOME && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV CLOUD_CODE_HOME ${PARSE_HOME}/cloud
COPY cloud/cloud $CLOUD_CODE_HOME/cloud

WORKDIR $PARSE_HOME
RUN npm install

## ENV
ENV CLOUD_CODE_MAIN ${CLOUD_CODE_HOME}/cloud/main.js
ENV PORT 1337

EXPOSE $PORT
VOLUME $CLOUD_CODE_HOME

ENV SSH_PORT 2022
EXPOSE $SSH_PORT

COPY ssh-add-key /usr/bin/ssh-add-key

RUN useradd -s /bin/bash git
RUN echo "git ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p /parse-cloud-code && \
    chown -R git:git /parse-cloud-code && \
    chown -R git:git /parse/cloud

ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0527A9B7 && \
    gpg --verify /tini.asc && \
    chmod a+x /tini

ADD docker-entrypoint.sh /
ENTRYPOINT ["/tini", "--", "/docker-entrypoint.sh"]
CMD ["npm", "start"]
