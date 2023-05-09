variable "identity_domain_id" {
  default = "DEFAULT"
}

data "oci_identity_domain" "test_domain" {
  domain_id = var.identity_domain_id
}

output idcs_endpoint {
  value = data.oci_identity_domain.test_domain.url
}

variable "idcs_access_token" {
  default = ""
}

resource "oci_integration_integration_instance" "opensearch_oic" {
  count = var.idcs_access_token?1:0
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

