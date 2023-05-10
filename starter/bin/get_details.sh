#!/bin/bash
export BIN_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export ROOT_DIR=${BIN_DIR%/*}
cd $ROOT_DIR

. ./env.sh

get_attribute_from_tfstate "STREAM_BOOSTRAPSERVER" "opensearch_stream_pool" "kafka_settings[0].bootstrap_servers"
get_attribute_from_tfstate "STREAM_OCID" "opensearch_stream_pool" "id"
get_attribute_from_tfstate "TENANCY_NAME" "tenant_details" "name"

echo "COMPARTMENT_OCID=$TF_VAR_compartment_ocid"
echo "STREAM_BOOSTRAPSERVER=$STREAM_BOOSTRAPSERVER"
# echo "TENANCY_NAME=$TENANCY_NAME"
echo "STREAM_USERNAME=$TENANCY_NAME/$TF_VAR_username/$STREAM_OCID"
echo "STREAM_USERNAME=tenancyname/oracleidentitycloudservice/name@domain.com/ocid1.streampool.oc1.eu-frankfurt-1.amaccccccccfsdfsdxfa"
echo "# OPENSEARCH_USER=opensearch-user"
echo "# OPENSEARCH_PWD=LiveLab--123"
echo "COMPUTE_PUBLIC-IP=$COMPUTE_IP"
echo "##COMPUTE_PRIVATE-KEY##"
echo "##OPENSEARCH_HOST##"

