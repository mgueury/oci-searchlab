resource "oci_identity_policy" "opensearch-policy" {
  name           = "opensearch-policy"
  description    = "Opensearch policy created by terraform"
  compartment_id = local.lz_appdev_cmp_ocid

  statements = [
    "Allow service opensearch to manage vnics in compartment id ${local.lz_appdev_cmp_ocid}",
    "Allow service opensearch to use subnets in compartment id ${local.lz_appdev_cmp_ocid}",
    "Allow service opensearch to use network-security-groups in compartment id ${local.lz_appdev_cmp_ocid}",
    "Allow service opensearch to manage vcns in compartment id ${local.lz_appdev_cmp_ocid}"
  ]
}

resource "oci_opensearch_opensearch_cluster" "opensearch_cluster" {
  depends_on = [oci_identity_policy.opensearch-policy]

  #Required
  compartment_id                     = local.lz_appdev_cmp_ocid
  data_node_count                    = 1
  data_node_host_memory_gb           = 32
  data_node_host_ocpu_count          = 2
  data_node_host_type                = "FLEX"
  data_node_storage_gb               = 50
  display_name                       = "opensearch-cluster"
  master_node_count                  = 1
  master_node_host_memory_gb         = 16
  master_node_host_ocpu_count        = 1
  master_node_host_type              = "FLEX"
  opendashboard_node_count           = 1
  opendashboard_node_host_memory_gb  = 16
  opendashboard_node_host_ocpu_count = 2
  software_version                   = "1.2.4"
  subnet_compartment_id              = local.lz_network_cmp_ocid
  subnet_id                          = data.oci_core_subnet.starter_public_subnet.id
  vcn_compartment_id                 = local.lz_network_cmp_ocid
  vcn_id                             = oci_core_vcn.starter_vcn.id
}

data "oci_opensearch_opensearch_clusters" "opensearch_clusters" {
  #Required
  compartment_id = local.lz_appdev_cmp_ocid
}