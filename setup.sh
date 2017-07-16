#!/bin/bash

set -e
host="localhost"
mysql_port1=3306
mysql_port2=3307
connector_jar="mysql-connector-java-5.1.36-bin.jar"
apim_instance_count=2
synapse_folder_path="repository/deployment/server/synapse-configs/default"

function check_container_exists() {
    name=$1
    if [ "$(docker ps -q -f name=${name})" ]; then
        echo "Error: Container ${name} exist! Run the clean.sh and try again."
        exit 1;
    fi
}

function wait_for_port() {
    port=$1
    while ! echo exit | (nc localhost ${port} > /dev/null); do sleep 2; done
}

echo "Starting API-M database container..."
check_container_exists "wso2-apim-db"
docker run --name "wso2-apim-db" -p ${mysql_port1}:3306 -e MYSQL_ROOT_PASSWORD=mysql \
                        -e MYSQL_USER=mysql \
                        -e MYSQL_PASSWORD=mysql \
                        -e MYSQL_DATABASE=wso2apim_db -d mysql:5.5

echo "Starting WSO2 API-M Analytics database container..."
check_container_exists "wso2-apim-analytics-db"
docker run --name "wso2-apim-analytics-db" -p ${mysql_port2}:3306 -e MYSQL_ROOT_PASSWORD=mysql \
                        -e MYSQL_USER=mysql \
                        -e MYSQL_PASSWORD=mysql \
                        -e MYSQL_DATABASE=wso2apim_analytics_db -d mysql:5.5



echo "Extracting API-M distribution..."
unzip dist/wso2am-2.1.0.zip

if (( apim_instance_count == 1 )); then
    echo "Creating API-M node 1..."
    mv "wso2am-2.1.0" "wso2am-2.1.0-1"
else
    echo "Creating API-M node1..."
    cp -r "wso2am-2.1.0" "wso2am-2.1.0-1"
    echo "Creating API-M node2..."
    mv "wso2am-2.1.0" "wso2am-2.1.0-2"

    echo "Creating symlink for API synchronization..."
    rm -rf wso2am-2.1.0-2/${synapse_folder_path}/*
    ln -s wso2am-2.1.0-1/${synapse_folder_path}/* wso2am-2.1.0-2/${synapse_folder_path}
    ls -l wso2am-2.1.0-2/${synapse_folder_path}
fi

echo "Extracting API-M analytics distribution..."
unzip dist/wso2am-analytics-2.1.0.zip

echo "Copying MySQL connector JAR file..."
cp dist/${connector_jar} wso2am-2.1.0-1/repository/components/lib/
if (( apim_instance_count == 2 )); then
    cp dist/${connector_jar} wso2am-2.1.0-2/repository/components/lib/
fi
cp dist/${connector_jar} wso2am-analytics-2.1.0/repository/components/lib/


echo "Copying API-M node 1 configurations..."
cp -r conf/wso2am-2.1.0-1/ wso2am-2.1.0-1/

if (( apim_instance_count == 2 )); then
    echo "Copying API-M node 2 configurations..."
    cp -r conf/wso2am-2.1.0-1/ wso2am-2.1.0-2/
    cp -r conf/wso2am-2.1.0-2/ wso2am-2.1.0-2/
fi

echo "Copying API-M analytics configurations..."
cp -r conf/wso2am-analytics-2.1.0/ wso2am-analytics-2.1.0/

echo "Waiting API-M database to start on ${host}:${mysql_port1}"
wait_for_port ${mysql_port1}
echo "API-M database became ready!"

echo "Waiting API-M analytics database to start on ${host}:${mysql_port2}"
wait_for_port ${mysql_port2}
echo "API-M Analytics database became ready!"

echo "Starting WSO2 API-M analytics node..."
sh "wso2am-analytics-2.1.0/bin/wso2server.sh" -Dsetup start
wait_for_port 9444
echo "WSO2 API-M analytics node started!"

echo "Starting WSO2 API-M node 1..."
sh wso2am-2.1.0-1/bin/wso2server.sh -Dsetup start
wait_for_port 9443
echo "WSO2 API-M node 1 started!"

if (( apim_instance_count == 2 )); then
    echo "Starting WSO2 API-M node 2..."
    sh wso2am-2.1.0-2/bin/wso2server.sh -Dsetup start
    wait_for_port 9445
    echo "WSO2 API-M node 2 started!"
fi

echo "Setup completed!"