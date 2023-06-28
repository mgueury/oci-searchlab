#!/bin/bash
export OIC_HOST=${OIC_HOST}
export OIC_CLIENT_ID=${OIC_CLIENT_ID} 
export OIC_CLIENT_SECRET=${OIC_CLIENT_SECRET}
export OIC_SCOPE=${OIC_SCOPE}
export IDCS_URL=${IDCS_URL}
export AGENT_GROUP=${AGENT_GROUP} 
export OPENSEARCH_HOST=${OPENSEARCH_HOST}

env > /home/opc/env2.log

cd /home/opc
while [ ! -f ./oic_install_agent.sh ]; do 
  echo "." >> /home/opc/wait.log
  sleep 1; 
done

chmod +x ./oic_install_agent.sh
sudo -Eu opc bash -c './oic_install_agent.sh > /tmp/oic_install_agent.log'
