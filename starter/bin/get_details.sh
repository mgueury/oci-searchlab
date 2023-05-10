#!/bin/bash
export BIN_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export ROOT_DIR=${BIN_DIR%/*}
cd $ROOT_DIR

. ./env.sh

get_attribute_from_tfstate "STREAM_BOOSTRAPSERVER" "opensearch_stream_pool" "kafka_settings[0].bootstrap_servers"
get_attribute_from_tfstate "STREAM_OCID" "opensearch_stream_pool" "id"
get_attribute_from_tfstate "TENANCY_NAME" "tenant_details" "name"
get_attribute_from_tfstate "OPENSEARCH_HOST" "opensearch_cluster" "opensearch_fqdn"

opensearch_fqdn

# echo "TENANCY_NAME=$TENANCY_NAME"
echo "COMPARTMENT_OCID=$TF_VAR_compartment_ocid"
echo "STREAM_BOOSTRAPSERVER=$STREAM_BOOSTRAPSERVER"
echo "STREAM_USERNAME=$TENANCY_NAME/$TF_VAR_username/$STREAM_OCID"
echo "AUTH_TOKEN=$TF_VAR_auth_token"

echo "COMPUTE_PUBLIC-IP=$COMPUTE_IP"
echo "OPENSEARCH_HOST=$OPENSEARCH_HOST"

echo "# OPENSEARCH_USER=opensearch-user"
echo "# OPENSEARCH_PWD=LiveLab--123"

echo -n | openssl s_client -connect $STREAM_BOOSTRAPSERVER | sed -ne  '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ociStreaming.cert
keytool -keystore oss_store.jks -alias OSSStream -import -file ociStreaming.cert -storepass changeit -noprompt
echo "File oss_store.jks created"


