resource "oci_integration_integration_instance" "opensearch_oic" {
  #Required
  compartment_id = local.lz_appdev_cmp_ocid
  display_name  = "${var.prefix}-oic"  
  # OIC GEN 3 
  integration_instance_type = "STANDARDX"
  is_byol                   = "true"
  message_packs             = "1"
  # idcs_at                   = var.integration_instance_idcs_access_token
  is_visual_builder_enabled = true
  freeform_tags             = local.freeform_tags  
}

