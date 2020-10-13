##############################################################################
# Cluster sVariables
##############################################################################

variable workers {
    description = "List of worker nodes in the cluster"
    type        = list(string)
    default     = []
}

variable worker_count {
    type        = number
    description = "The number of workers. This variable is here because of terraform calculation limitiations"
    default     = 1
}

variable cluster_name {
    description = "Name of the cluster where resources will be deployed"
    type        = string
}

variable resource_group_id {
    type        = string
    description =  "ID of resource group of the cluster"
}

variable kube_config_path {
    type        = string
    description = "Path to kubeconfig"
}

variable calico_config_path {
     type        = string    
    description = "Path to calicoconfig"
}

variable await_complete {
  type        = string
  description = "A variable that will force a bash script to wait until it is able to be calculated"
}


##############################################################################