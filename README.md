# WSO2 API Manager Deployment Guide

This repository contains configurations required for setting up WSO2 API Manager 2.1.0 and WSO2 API Manager Analytics 2.1.0 according to all-in-one deployment pattern on a local machine.

## Deployment Architecture

The following diagram illustrates the deployment architecture:
![](images/deployment-architecture.png)

## Quick Start

- Close this repository:

  ````
  git clone https://github.com/imesh/wso2-apim-deployment-guide.git
  ````

- Download WSO2 API Manager 2.1.0 and WSO2 API Manager Analytics 2.1.0 distributions via [WSO2 Update Manager](http://wso2.com/api-management/#download) and copy them to the ```dist/``` folder.

- Install JDK 8 and update $PATH variable. 

- Execute ```setup.sh``` script to setup the deployment:

  ````
  ./setup.sh
  ````

- Once the work is completed, execute ```clean.sh``` script to remove the deployment:

  ````
  ./clean.sh
  ````