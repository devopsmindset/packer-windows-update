FROM debian:buster

ENV PACKER_VERSION=1.5.6

RUN apt-get -y update && apt-get -y install wget && apt-get -y install tar && apt-get -y install git && apt-get -y install unzip && apt-get -y install zip && apt-get -y install curl && \
    wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin && \
    rm -f packer_${PACKER_VERSION}_linux_amd64.zip && \
    wget https://github.com/rgl/packer-provisioner-windows-update/releases/download/v0.9.0/packer-provisioner-windows-update-linux.tgz && \
    tar -xf packer-provisioner-windows-update-linux.tgz && \
    rm packer-provisioner-windows-update-linux.tgz && \
    mv packer-provisioner-windows-update bin/packer-provisioner-windows-update && \
	chmod 777 bin/packer-provisioner-windows-update

RUN apk add --no-cache make musl-dev go

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

# Create config folders
RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin /root/.gdrive

# Install gDrive
RUN go get github.com/prasmussen/gdrive

ENTRYPOINT ["/bin/bash"]