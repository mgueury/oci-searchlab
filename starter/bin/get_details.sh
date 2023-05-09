#!/bin/bash
export BIN_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export ROOT_DIR=${BIN_DIR%/*}
cd $ROOT_DIR

. ./env.sh

echo "COMPARTMENT_OCID=$TF_VAR_compartment_ocid"
echo "STREAM_BOOSTRAPSERVER=cell-1.streaming.eu-frankfurt-1.oci.oraclecloud.com:9092"
echo "STREAM_USERNAME=tenancyname/oracleidentitycloudservice/name@domain.com/ocid1.streampool.oc1.eu-frankfurt-1.amaccccccccfsdfsdxfa"
echo "# OPENSEARCH_USER=opensearch-user"
echo "# OPENSEARCH_PWD=LiveLab--123"
echo "##COMPUTE_PUBLIC-IP##"
echo "##COMPUTE_PRIVATE-KEY##"
