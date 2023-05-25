echo OIC_HOST=$OIC_HOST
echo OCI_USER=$OCI_USER
echo OCI_PASSWORD=$OCI_PASSWORD
echo AGENT_GROUP=$AGENT_GROUP
echo OPENSEARCH_HOST=$OPENSEARCH_HOST

export OIC_NAME=`echo $OIC_HOST | sed 's#https://##' | sed 's/\..*//'`
export OIC_DOMAIN=`echo $OIC_HOST | sed 's/.*integration\.//'`

echo OIC_NAME=$OIC_NAME
echo OIC_DOMAIN=$OIC_DOMAIN

# Download the OIC_agent
# OIC Gen 2
# curl -X GET  $OIC_HOST/ic/api/integration/v1/agents/binaries/connectivity -u $OCI_USER:$OCI_PASSWORD -o $HOME/oic_connectivity_agent.zip
curl -X GET https://design.integration.$OIC_DOMAIN/ic/api/integration/v1/agents/binaries/connectivity?integrationInstance=$OIC_NAME -u $OCI_USER:$OCI_PASSWORD -o $HOME/oic_connectivity_agent.zip
ls -a

# Unzip it
mkdir oic_agent
cd oic_agent
unzip ../oic_connectivity_agent.zip


# Configure it
mv InstallerProfile.cfg InstallerProfile.orig
cat > ./InstallerProfile.cfg << EOT
# Required Parameters
# oic_URL format should be https://hostname:sslPort
oic_URL=$OIC_HOST
agent_GROUP_IDENTIFIER=$AGENT_GROUP

#Optional Parameters
oic_USER=$OCI_USER
oic_PASSWORD=$OCI_PASSWORD

# Proxy Parameters
# proxy_NON_PROXY_HOSTS: a list of hosts that should be reached directly, bypassing the proxy. This is a list of patterns separated by '|'.
proxy_HOST=
proxy_PORT=
proxy_USER=
proxy_PASSWORD=
proxy_NON_PROXY_HOSTS=
EOT

# Install JDK 11
sudo yum install java-11-openjdk-devel -y

# Get the SSL certificate of OpenSearch since it is invalid
echo -n | openssl s_client -connect $OPENSEARCH_HOST:9200 -servername $OPENSEARCH_HOST | openssl x509 > /tmp/opensearch.cert
cat /tmp/opensearch.cert 
cd agenthome/agent/cert/ 
ls keystore.jks
keytool -importcert -keystore keystore.jks -storepass changeit -alias opensearch -noprompt -file /tmp/opensearch.cert
cd ../../..

# Create a start command
echo 'java -jar connectivityagent.jar > agent.log 2>&1 &' > start.sh
chmod +x start.sh

./start.sh

## XX ideally there should something to start the start command on reboot of the server
