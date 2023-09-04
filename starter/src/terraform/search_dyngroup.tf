
variable oic_appid {}

resource "oci_identity_domains_dynamic_resource_group" "search-fn-dyngroup" {
    #Required
    display_name = "${var.prefix}-fn-dyngroup"
    idcs_endpoint = local.idcs_url
    matching_rule = "ALL {resource.type = 'fnfunc', resource.compartment.id = '${var.compartment_ocid}'}"
    schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:DynamicResourceGroup"]
}
resource "oci_identity_domains_dynamic_resource_group" "search-oic-dyngroup" {
    #Required
    display_name = "${var.prefix}-oic-dyngroup"
    idcs_endpoint = local.idcs_url
    matching_rule = "ALL {resource.id = '${var.oic_appid}'}"
    schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:DynamicResourceGroup"]
}

resource "oci_identity_policy" "search-policy" {
  name           = "${var.prefix}-policy"
  description    = "${var.prefix} policy"
  compartment_id = var.compartment_ocid

  statements = [
    "Allow service opensearch to manage vnics in compartment id ${var.compartment_ocid}",
    "Allow service opensearch to use subnets in compartment id ${var.compartment_ocid}",
    "Allow service opensearch to use network-security-groups in compartment id ${var.compartment_ocid}",
    "Allow service opensearch to manage vcns in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.idcs_domain_name}/${var.prefix}-fn-dyngroup to manage objects in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${var.idcs_domain_name}/${var.prefix}-oic-dyngroup to manage all-resources in compartment id ${var.compartment_ocid}"
  ]
}
