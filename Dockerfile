FROM summerwind/actions-runner:latest

ENV GOLANG_VERSION 1.19.1
ENV NODE_VERSION 18.9.0

# do root things
USER root 

## GOLANG
ENV PATH=/usr/local/go/bin:$PATH
RUN set -eux; \
    wget -O go.tgz "https://dl.google.com/go/go$GOLANG_VERSION.linux-amd64.tar.gz" --progress=dot:giga; \
    \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz; \
    \
    go version

ENV GOPATH /go
ENV PATH=$GOPATH/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

## NODE
#RUN groupadd --gid 1000 node \
#    && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

RUN curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
    && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && rm "node-v$NODE_VERSION-linux-x64.tar.xz" \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    # smoke tests
    && node --version \
    && npm --version

# runner loads env from /etc/environment so make sure our path is correct there
RUN echo "PATH=${PATH}" > /etc/environment \
    && echo "ImageOS=${ImageOS}" >> /etc/environment

# reset user to runner
USER runner