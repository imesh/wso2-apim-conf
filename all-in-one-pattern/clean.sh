#!/bin/bash

function wait_for_process_to_exit() {
    port=$1
    while echo exit | (nc localhost ${port} > /dev/null); do sleep 2; done
}

printf "Do you really want to clear the deployment (y/n)? "
read -r terminate
if [[ $terminate == "n" || $terminate == "N" ]]; then
    exit 1;
fi

echo "Removing MySQL database containers..."
docker rm -f "wso2-apim-db"
docker rm -f "wso2-apim-analytics-db"

echo "Stopping API-M analytics node..."
sh "wso2am-analytics-2.1.0/bin/wso2server.sh" -Dsetup stop
echo "Stopping API-M node 1..."
sh "wso2am-2.1.0-1/bin/wso2server.sh" -Dsetup stop

if [ -d "wso2am-2.1.0-2/" ]; then
    echo "Stopping API-M node 2..."
    sh "wso2am-2.1.0-2/bin/wso2server.sh" -Dsetup stop
fi

echo "Waiting for API-M analytics to stop..."
wait_for_process_to_exit 9444
echo "Waiting for API-M node 1 to stop..."
wait_for_process_to_exit 9443

if [ -d "wso2am-2.1.0-2/" ]; then
    echo "Waiting for API-M node 2 to stop..."
    wait_for_process_to_exit 9445
fi

echo "Removing WSO2 API-M distributions..."

if [ -d "wso2am-2.1.0" ]; then
    rm -rf "wso2am-2.1.0"
fi
if [ -d "wso2am-2.1.0-1/" ]; then
    rm -rf "wso2am-2.1.0-1"
fi
if [ -d "wso2am-2.1.0-2/" ]; then
    rm -rf "wso2am-2.1.0-2"
fi

rm -rf "wso2am-analytics-2.1.0"

echo "Clean process completed!"