resource "oci_identity_dynamic_group" "search-fn-dyngroup" {
  name           = "${var.prefix}-fn-dyngroup"
  description    = "Function Dyngroup"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ALL {resource.type = 'fnfunc', resource.compartment.id = '${var.compartment_ocid}'}"
}

resource "oci_identity_dynamic_group" "search-oic-dyngroup" {
  name           = "${var.prefix}-oic-dyngroup"
  description    = "OIC Dyngroup"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ALL {resource.type = 'integration', resource.compartment.id = '${var.compartment_ocid}'}"
}

resource "oci_identity_policy" "search-policy" {
  name           = "${var.prefix}-policy"
  description    = "${var.prefix} policy"
  compartment_id = var.tenancy_ocid

  statements = [
    "Allow service opensearch to manage vnics in compartment id ${var.compartment_ocid}",
    "Allow service opensearch to use subnets in compartment id ${var.compartment_ocid}",
    "Allow service opensearch to use network-security-groups in compartment id ${var.compartment_ocid}",
    "Allow service opensearch to manage vcns in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.prefix}-fn-dyngroup to manage objects in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.prefix}-oic-dyngroup to manage all-resources in tenancy"
  ]
}