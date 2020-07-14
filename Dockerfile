FROM alpine

ENV PACKER_VERSION=1.5.6 \
    PACKER_SHA256SUM=2abb95dc3a5fcfb9bf10ced8e0dd51d2a9e6582a1de1cab8ccec650101c1f9df

ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip ./ \
    https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS ./

RUN apk update && apk add --no-cache wget && apk add --no-cache tar && apk add --update git bash wget openssl && apk add --no-cache curl && \
    sed -i '/.*linux_amd64.zip/!d' packer_${PACKER_VERSION}_SHA256SUMS && \
    sha256sum -cs packer_${PACKER_VERSION}_SHA256SUMS && \
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
