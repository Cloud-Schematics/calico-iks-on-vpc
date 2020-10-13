# Calico

This module creates Calico policies on an IKS on VPC cluster using null scripts. In order to use the module the [Kubernetes Terraform Provider](https://www.terraform.io/docs/providers/kubernetes/index.html) must be setup within your workspace. If you're running this in a local container, make sure calicoctl is installed.

---

## Table of Contents

1. [Setup](##Setup)
2. [Module Variables](##Module-Variables)
3. [Outputs](##Outputs) (optional)
4. [As a Module in a Larger Architecture](##As-a-Module-in-a-Larger-Architecture)

---

## Setup

Ensure that you have an IKS cluster setup. You can get the `calico_config_path` from `data.ibm_container_cluster_config.cluster.calico_config_file_path`. Ensure in your `ibm_container_cluster_config` block that `network` is set to true so that it will download the needed Calico files.

```
data ibm_container_cluster_config cluster {
  cluster_name_id   = ibm_container_vpc_cluster.cluster.name
  resource_group_id = var.resource_group_id
  admin             = true
  network           = true
}
```

---

## Module Variables

Variable | Type | Description | Default
---------|------|-------------|--------
`workers` | list(string) | List of worker nodes in the cluster | `[]`
`worker_count` | number | The number of workers. This variable is here because of terraform calculation limitiations | `1`
`cluster_name` | string | Name of the cluster where resources will be deployed |
`resource_group_id` | string | ID of resource group of the cluster |
`kube_config_path` | string | Path to kubeconfig |
`calico_config_path` | string | Path to calicoconfig |
`await_complete` | string | A variable that will force a bash script to wait until it is able to be calculated. Use this only if the module needs to wait to be installed |

---

## As a Module in a Larger Architecture

```
##############################################################################
# Calico Setup
##############################################################################

module calico {
    source             = "./calico"
    cluster_name       = var.cluster_name
    workers            = var.workers
    worker_count       = var.worker_count
    resource_group_id  = var.resource_group_id
    kube_config_path   = var.kube_config_path
    calico_config_path = var.calico_config_path
    await_complete     = local.lognda_sysdig_complete
}

##############################################################################
```
