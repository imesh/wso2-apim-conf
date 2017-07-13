# WSO2 API Manager VM Deployment

This repository contains bash scripts and configurations required for setting up WSO2 API Manager all-in-one deployment pattern on on a local machine.

## Quick Start

- Close this repository:

  ````
  git clone https://github.com/imesh/wso2-apim-vm-deployment.git
  ````

- Copy WSO2 API Manager 2.1.0 and WSO2 API Manager Analytics 2.1.0 distributions to the ```dist/``` folder.

- Install JDK 8 and update $PATH variable. 

- Execute ```setup.sh``` script:

  ````
  ./setup.sh
  ````

- Execute ```clean.sh``` script to remove the deployment:

  ````
  ./clean.sh
  ````