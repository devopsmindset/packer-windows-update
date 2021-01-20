# packer-windows-update
## Description:
Docker image created from hashicorp/packer image that includes packer-provisioner-windows-update plugin. It also includes GoLang and gDrive tool.\
It uses an Alpine image base.
## Usage
````
docker pull devopsmindset/packer-windows-update:latest
docker run -i -t <args> devopsmindset/packer-windows-update:latest <command>
````
## Current versions
- Packer 1.5.6
- packer-provisioner-windows-update 0.9.0
- GoLang 1.13.11
- gdrive 2.1.0
- Python 3.6.8