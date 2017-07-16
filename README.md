# WSO2 API Manager Deployment Automation

This repository contains configurations required for setting up WSO2 API Manager 2.1.0 and WSO2 API Manager Analytics 2.1.0 according to all-in-one deployment pattern on a local machine.

## Deployment Components

- API Manager MySQL database container
- API Manager Anlaytics MySQL database container
- API Manager instances
- API Manager Analytics instance

## Quick Start

- Close this repository:

  ````
  git clone https://github.com/imesh/wso2-apim-deployment-automation.git
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