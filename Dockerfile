FROM golang:alpine

ENV PACKER_DEV=1

RUN apk add --no-cache tar
RUN apk update && apk add --no-cache wget
RUN apk add --update git bash openssl
RUN go get github.com/mitchellh/gox
RUN go get github.com/hashicorp/packer

RUN cd /bin
RUN wget https://github.com/rgl/packer-provisioner-windows-update/releases/download/v0.9.0/packer-provisioner-windows-update-linux.tgz
RUN tar -xf packer-provisioner-windows-update-linux.tgz

WORKDIR $GOPATH/src/github.com/hashicorp/packer

RUN /bin/bash scripts/build.sh

WORKDIR $GOPATH
ENTRYPOINT ["bin/packer"]







