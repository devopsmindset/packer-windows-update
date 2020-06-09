FROM debian:buster
MAINTAINER "The Packer Team <packer@hashicorp.com>"

ENV PACKER_VERSION=1.5.6
ENV PACKER_SHA256SUM=2abb95dc3a5fcfb9bf10ced8e0dd51d2a9e6582a1de1cab8ccec650101c1f9df

RUN apt-get -y update && apt-get -y install wget && apt-get -y install tar && apt-get -y install git && \
    sed -i '/.*linux_amd64.zip/!d' packer_${PACKER_VERSION}_SHA256SUMS && \
    sha256sum -cs packer_${PACKER_VERSION}_SHA256SUMS && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin && \
    rm -f packer_${PACKER_VERSION}_linux_amd64.zip && \
    wget https://github.com/rgl/packer-provisioner-windows-update/releases/download/v0.9.0/packer-provisioner-windows-update-linux.tgz && \
    tar -xf packer-provisioner-windows-update-linux.tgz && \
    rm packer-provisioner-windows-update-linux.tgz && \
    mv packer-provisioner-windows-update bin/packer-provisioner-windows-update && \
	chmod 777 bin/packer-provisioner-windows-update


ENTRYPOINT ["/bin/bash"]