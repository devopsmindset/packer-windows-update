FROM debian:buster

ENV PACKER_VERSION=1.5.6
ENV GO_VERSION=1.13.3
ENV PYTHON_VERSION=3.6.8
ENV PYTHON_VERSION_PREFIX=3.6
ENV ANSIBLE_VERSION=2.9.13


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
	apt-get -y install libffi-dev && apt-get -y install python-dev && \
	cd /usr/src && \
	wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
	tar xzf Python-${PYTHON_VERSION}.tgz && \
	cd Python-${PYTHON_VERSION} && \
	./configure && \
	make altinstall

RUN pip${PYTHON_VERSION_PREFIX} install --upgrade pip && \
	pip${PYTHON_VERSION_PREFIX} install cryptography && \
	pip${PYTHON_VERSION_PREFIX} install pywinrm && \
	pip${PYTHON_VERSION_PREFIX} install ansible==${ANSIBLE_VERSION} && \
	pip${PYTHON_VERSION_PREFIX} install --upgrade azure-storage-blob


RUN mkdir /usr/local/share/ca-certificates && cd /usr/local/share/ca-certificates && \
	wget --no-check-certificate --no-verbose http://repository.kiosk.roche.com/public/certificates/roche.com/roche_com_enterprise.crt -O roche_com_enterprise.crt && \
	wget --no-check-certificate --no-verbose http://repository.kiosk.roche.com/public/certificates/roche.com/roche_com_root.crt -O roche_com_root.crt && \
	wget --no-check-certificate --no-verbose http://repository.kiosk.roche.com/public/certificates/roche.com/geo_trust.crt -O geo_trust.crt && \
	wget --no-check-certificate --no-verbose http://certinfo.roche.com/rootcerts/Roche%20G3%20Root%20CA.crt -O roche_com_CA1_G3.crt && \
	wget --no-check-certificate --no-verbose http://certinfo.roche.com/rootcerts/Roche%20Root%20CA%201%20-%20G2.crt -O roche_com_CA1_G2.crt && \
	wget --no-check-certificate --no-verbose http://certinfo.roche.com/rootcerts/Roche%20Root%20CA%201.crt -O roche_com_CA1.crt && \
	update-ca-certificates


RUN wget http://repository.kiosk.roche.com/thirdparty-local/com.vmware/VMware-ovftool/4/4.4.1/Linux/VMware-ovftool-4.4.1-16812187-lin.x86_64.bundle && \
	chmod 777 VMware-ovftool-4.4.1-16812187-lin.x86_64.bundle && \
	mkdir /opt/ovftool && \
	mv VMware-ovftool-4.4.1-16812187-lin.x86_64.bundle /opt/ovftool && \
    ./VMware-ovftool-4.4.1-16812187-lin.x86_64.bundle --eulas-agreed --console

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
