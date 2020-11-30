FROM debian:buster

ENV PACKER_VERSION=1.5.6
ENV GO_VERSION=1.13.3
ENV PYTHON_VERSION=3.6.8

RUN apt-get -y update && apt-get -y install wget && apt-get -y install tar && apt-get -y install git && apt-get -y install unzip && apt-get -y install zip && apt-get -y install curl && \
    wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin && \
    rm -f packer_${PACKER_VERSION}_linux_amd64.zip && \
    wget https://github.com/rgl/packer-provisioner-windows-update/releases/download/v0.9.0/packer-provisioner-windows-update-linux.tgz && \
    tar -xf packer-provisioner-windows-update-linux.tgz && \
    rm packer-provisioner-windows-update-linux.tgz && \
    mv packer-provisioner-windows-update bin/packer-provisioner-windows-update && \
	chmod 777 bin/packer-provisioner-windows-update

RUN apt-get -y update && apt-get -y install build-essential && \
    apt-get -y install libreadline-gplv2-dev && apt-get -y install libncursesw5-dev && apt-get -y install libssl-dev && \
	apt-get -y install libsqlite3-dev && apt-get -y install tk-dev && apt-get -y install libgdbm-dev && \
	apt-get -y install libc6-dev && apt-get -y install libbz2-dev && \
	cd /usr/src && \
	wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
	tar xzf Python-${PYTHON_VERSION}.tgz && \
	cd Python-${PYTHON_VERSION} && \
	./configure && \
	make altinstall

RUN wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
	tar -xvf go${GO_VERSION}.linux-amd64.tar.gz && \
	mv go /usr/local

# Configure Go
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

# Create config folders
RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin /root/.gdrive

# Install gDrive
RUN go get github.com/prasmussen/gdrive

ENTRYPOINT ["/bin/bash"]