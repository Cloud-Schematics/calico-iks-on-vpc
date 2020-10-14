##############################################################################
# Provider
##############################################################################

provider ibm {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.ibm_region
  ibmcloud_timeout = 60
  generation       = var.generation
}

##############################################################################

##############################################################################
# Resource Group
##############################################################################

data ibm_resource_group group {
  name = var.resource_group
}

##############################################################################


##############################################################################
# Cluster Data
##############################################################################

data ibm_container_vpc_cluster cluster {
  name              = var.cluster_name
  resource_group_id = data.ibm_resource_group.group.id
}

data ibm_container_cluster_config cluster {
  cluster_name_id   = var.cluster_name
  resource_group_id = data.ibm_resource_group.group.id
  admin             = true
  network           = true
}

##############################################################################


##############################################################################
# Example resource to force calico to wait until done. This can be done with
# any resource block
##############################################################################

resource null_resource example_await {
  provisioner local-exec {
    command = <<BASH
sleep 60
    BASH
  }
}

##############################################################################


##############################################################################
# Calico Setup
##############################################################################

module calico {
    source             = "./calico"
    await_complete     = null_resource.example_await.id
    cluster_name       = var.cluster_name
    workers            = data.ibm_container_vpc_cluster.cluster.workers
    worker_count       = length(data.ibm_container_vpc_cluster.cluster.workers)
    resource_group_id  = data.ibm_resource_group.group.id
    kube_config_path   = data.ibm_container_cluster_config.cluster.config_file_path
    calico_config_path = data.ibm_container_cluster_config.cluster.calico_config_file_path
}

##############################################################################