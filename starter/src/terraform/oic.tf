variable "identity_domain_id" {
  default = "DEFAULT"
}

data "oci_identity_domains" "domains" {
  compartment_id = var.tenancy_ocid
}

output idcs_url {
  value = data.oci_identity_domains.domains.domains[0].url
}

variable "idcs_access_token" {
  default = ""
}

resource "oci_integration_integration_instance" "opensearch_oic" {
  count = var.idcs_access_token==""?0:1
  #Required
  compartment_id = local.lz_appdev_cmp_ocid
  display_name  = "${var.prefix}-oic"  
  # OIC GEN 3 
  integration_instance_type = "STANDARDX"
  is_byol                   = "true"
  message_packs             = "1"
  idcs_at                   = var.idcs_access_token
  # is_visual_builder_enabled = true
  freeform_tags             = local.freeform_tags  
}

