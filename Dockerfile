FROM summerwind/actions-runner:latest

ENV PATH=/usr/local/go/bin:$PATH
ENV GOLANG_VERSION 1.19.1

# do root things
USER root 

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
RUN echo "PATH=${PATH}" > /etc/environment \
    && echo "ImageOS=${ImageOS}" >> /etc/environment

# reset user to runner
USER runner