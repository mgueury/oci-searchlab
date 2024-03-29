variable oic_client_id {}
variable oic_client_secret {}
variable oic_scope {}
variable idcs_url { default = "" }
variable idcs_domain_name { default = "Default" }

data "oci_identity_domains" "starter_domains" {
    #Required
    compartment_id = var.tenancy_ocid
    display_name = var.idcs_domain_name
}

locals {
  idcs_url = (var.idcs_url!="")?var.idcs_url:data.oci_identity_domains.starter_domains.domains[0].url
}

# Defines the number of instances to deploy
data "template_file" "user_data" {
  template = file("./oic_agent_userdata.sh")
  vars = {
    OIC_OCID = var.oic_ocid
    # Needed for destroy
    OIC_HOST = coalesce(data.oci_integration_integration_instance.oic.instance_url,"-")
    OIC_CLIENT_ID = var.oic_client_id
    OIC_CLIENT_SECRET = var.oic_client_secret
    OIC_SCOPE = var.oic_scope
    IDCS_URL = local.idcs_url
    AGENT_GROUP = "OPENSEARCH_AGENT_GROUP"
    OPENSEARCH_HOST = oci_opensearch_opensearch_cluster.opensearch_cluster.opensearch_fqdn
  }
}

resource "oci_core_instance" "starter_instance" {

  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = local.lz_appdev_cmp_ocid
  display_name        = "${var.prefix}-instance"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_shape_config_memory_in_gbs
  }

  create_vnic_details {
    subnet_id                 = data.oci_core_subnet.starter_public_subnet.id
    display_name              = "Primaryvnic"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "${var.prefix}-instance"
  }

  # XXXX Should be there only for Java
  agent_config {
    plugins_config {
      desired_state =  "ENABLED"
      name = "Oracle Java Management Service"
    }
    plugins_config {
      desired_state =  "ENABLED"
      name = "Management Agent"
    }
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(data.template_file.user_data.rendered)
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oraclelinux.images.0.id
  }

  connection {
    agent       = false
    host        = oci_core_instance.starter_instance.public_ip
    user        = "opc"
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    on_failure = continue
    inline = [
      "date"
    ]
  }

  provisioner "file" {
    connection {
      agent       = false
      timeout     = "5m"
      user        = "opc"
      private_key = var.ssh_private_key
      host        = oci_core_instance.starter_instance.*.public_ip[0]
    }

    source      = "oic_install_agent.sh"
    destination = "oic_install_agent.sh"
  }

  freeform_tags = local.freeform_tags
}

# Output the private and public IPs of the instance
output "instance_private_ips" {
  value = [oci_core_instance.starter_instance.private_ip]
}

output "instance_public_ips" {
  value = [oci_core_instance.starter_instance.public_ip]
}

output "idcs_url" {
  value = local.idcs_url
}

output "ui_url" {
  value = format("http://%s", oci_core_instance.starter_instance.public_ip)
}



