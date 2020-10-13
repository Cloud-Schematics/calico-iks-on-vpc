##############################################################################
# Account variables
##############################################################################

variable ibmcloud_api_key {
    description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
    type        = string
}

variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed"
    type        = string
}

variable generation {
    description = "Generation of VPC where cluster is deployed"
    default     = 2
}

variable resource_group {
    description = "Name for IBM Cloud Resource Group where resources will be deployed"
    type        = string
}

variable cluster_name {
    description = "Name of the cluster where resources will be deployed"
    type        = string
}

##############################################################################