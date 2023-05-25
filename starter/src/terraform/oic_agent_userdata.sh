#!/bin/bash
export OIC_HOST=${OIC_HOST}
export OCI_USER=${OCI_USER} 
export OCI_PASSWORD=${OCI_PASSWORD}
export AGENT_GROUP=${AGENT_GROUP} 
export OPENSEARCH_HOST=${OPENSEARCH_HOST}

env > /home/opc/env2.log

cd /home/opc
while [ ! -f ./oic_install_agent.sh ]; do 
  echo "." >> /home/opc/wait.log
  sleep 1; 
done

chmod +x ./oic_install_agent.sh
sudo su opc ./oic_install_agent.sh > /tmp/oic_install_agent.log