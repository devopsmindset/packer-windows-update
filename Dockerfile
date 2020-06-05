FROM debian:buster
MAINTAINER "The Packer Team <packer@hashicorp.com>"

ENV PACKER_VERSION=1.5.6
ENV PACKER_SHA256SUM=2abb95dc3a5fcfb9bf10ced8e0dd51d2a9e6582a1de1cab8ccec650101c1f9df

RUN apt-get -y update
RUN apt-get -y install tar
RUN apt-get -y install wget
RUN apt-get -y install git

RUN apt-get -y install packer

RUN wget https://github.com/rgl/packer-provisioner-windows-update/releases/download/v0.9.0/packer-provisioner-windows-update-linux.tgz
RUN tar -xf packer-provisioner-windows-update-linux.tgz
RUN rm packer-provisioner-windows-update-linux.tgz
RUN mv packer-provisioner-windows-update bin/packer-provisioner-windows-update


ENTRYPOINT ["/bin/bash"]