#!/bin/bash

sudo apt-get install unzip

wget https://releases.hashicorp.com/terraform/1.3.9/terraform_1.3.9_linux_amd64.zip

unzip terraform_1.3.9_linux_amd64.zip

sudo mv terraform /usr/local/bin/

terraform --version 



