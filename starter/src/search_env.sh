#!/bin/bash
export SRC_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export ROOT_DIR=${SRC_DIR%/*}
cd $ROOT_DIR

. ./env.sh

get_attribute_from_tfstate "STREAM_BOOSTRAPSERVER" "opensearch_stream_pool" "kafka_settings[0].bootstrap_servers"
get_attribute_from_tfstate "STREAM_OCID" "opensearch_stream_pool" "id"
get_attribute_from_tfstate "TENANCY_NAME" "tenant_details" "name"
get_attribute_from_tfstate "OPENSEARCH_HOST" "opensearch_cluster" "opensearch_fqdn"
get_attribute_from_tfstate "COMPUTE_IP" "starter_instance" "public_ip"

get_attribute_from_tfstate "FN_OCID" "starter_fn_function" "id"
get_attribute_from_tfstate "FN_INVOKE_ENDPOINT" "starter_fn_function" "invoke_endpoint"

echo 
echo "--------------------------"
echo "OCI SEARCH LAB Environment"
echo "--------------------------"

# echo "TENANCY_NAME=$TENANCY_NAME"
echo "COMPARTMENT_OCID=$TF_VAR_compartment_ocid"
echo "COMPUTE_PUBLIC-IP=$COMPUTE_IP"
echo "--------------------------"
echo "STREAM_BOOSTRAPSERVER=$STREAM_BOOSTRAPSERVER"
echo "STREAM_USERNAME=$TENANCY_NAME/$TF_VAR_username/$STREAM_OCID"
echo "AUTH_TOKEN=$TF_VAR_auth_token"
echo "--------------------------"
echo "FUNTION_ENDPOINT=$FN_INVOKE_ENDPOINT/20181201/functions/$FN_OCID"
echo "--------------------------"
echo "OPENSEARCH_HOST=$OPENSEARCH_HOST"
echo "OPENSEARCH_API_ENDPOINT=https://$OPENSEARCH_HOST:9200"

echo "# OPENSEARCH_USER=opensearch-user"
echo "# OPENSEARCH_PWD=LiveLab--123"

echo -n | openssl s_client -connect $STREAM_BOOSTRAPSERVER | sed -ne  '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ociStreaming.cert
keytool -keystore oss_store.jks -alias OSSStream -import -file ociStreaming.cert -storepass changeit -noprompt
echo "File oss_store.jks created"


https://