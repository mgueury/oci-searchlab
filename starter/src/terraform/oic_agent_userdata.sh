#!/bin/bash
# yum update -y
echo '################### mount NFS share #####################'
env > /home/opc/env.log

export oic_host=${oic_host}
export oci_user=${oci_user} 
export oci_password=${oci_password}
export agent_group=${agent_group} 
export opensearch_host=${opensearch_host}

env > /home/opc/env2.log

cd /home/opc
chmod +x ./oic_install_agent.sh
./oic_install_agent.sh > /tmp/oic_install_agent.log