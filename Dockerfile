FROM alpine:latest
MAINTAINER "The Packer Team <packer@hashicorp.com>"

ENV PACKER_VERSION=1.5.6
ENV PACKER_SHA256SUM=2abb95dc3a5fcfb9bf10ced8e0dd51d2a9e6582a1de1cab8ccec650101c1f9df

RUN apk add --no-cache tar
RUN apk update && apk add --no-cache wget
RUN apk add --update git bash wget openssl
RUN echo 'hosts: files dns' >> /etc/nsswitch.conf

ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip ./
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS ./

RUN sed -i '/.*linux_amd64.zip/!d' packer_${PACKER_VERSION}_SHA256SUMS
RUN sha256sum -cs packer_${PACKER_VERSION}_SHA256SUMS
RUN unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin
RUN rm -f packer_${PACKER_VERSION}_linux_amd64.zip

RUN wget https://github.com/rgl/packer-provisioner-windows-update/releases/download/v0.9.0/packer-provisioner-windows-update-linux.tgz
RUN tar -xf packer-provisioner-windows-update-linux.tgz
RUN rm packer-provisioner-windows-update-linux.tgz
RUN mv packer-provisioner-windows-update bin/packer-provisioner-windows-update


ENTRYPOINT ["/bin/bash"]