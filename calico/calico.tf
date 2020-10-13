##############################################################################
# Get Data For Cluster Workers
##############################################################################

resource null_resource await {
    provisioner local-exec {
        command=<<BASH
AWAIT=${var.await_complete}
        BASH
    }
}

data ibm_container_vpc_cluster_worker workers {
    count             = var.worker_count
    worker_id         = var.workers[count.index]
    cluster_name_id   = var.cluster_name
    resource_group_id = var.resource_group_id
    depends_on        = [null_resource.await]
}

locals {
    # Gets a flattened list of IP addresses for each worker within a cluster
    # Joins with /32 to create CIDR blocks
    # Adds /32 to last entry
    ip_address_list = "${
        join("/32", 
            flatten([
                for i in data.ibm_container_vpc_cluster_worker.workers:
                i.network_interfaces.*.ip_address
            ])
        )}/32"
}

##############################################################################


##############################################################################
# Add Calico Rules
##############################################################################


resource null_resource calico {
    provisioner local-exec {
        command = <<BASH
AWAIT=${var.await_complete}
export KUBECONFIG=${var.kube_config_path}
CONFIG=${var.calico_config_path}
sed -i "s%WORKER_IPS%${local.ip_address_list}%g" ${path.module}/config/template-deny-inner-nodes.yaml
echo "Applying Calico Policy to deny node ports for public IPs."
calicoctl apply -f ${path.module}/config/deny-kube-node-port-services.yaml --config=$CONFIG
calicoctl apply -f ${path.module}/config/template-deny-inner-nodes.yaml --config=$CONFIG
        BASH
    }
    provisioner local-exec {
        when    = "destroy"
        command = <<BASH
AWAIT=${var.await_complete}
export KUBECONFIG=${var.kube_config_path}
CONFIG=${var.calico_config_path}
sed -i "s%WORKER_IPS%${local.ip_address_list}%g" ${path.module}/config/template-deny-inner-nodes.yaml
calicoctl delete -f ${path.module}/config/deny-kube-node-port-services.yaml --config=$CONFIG
calicoctl delete -f ${path.module}/config/template-deny-inner-nodes.yaml --config=$CONFIG
        BASH
    }
}


##############################################################################


##############################################################################
# Outputs the null resource id when complete
##############################################################################

output complete {
    description = "Will return a string once the null resource for applying calico policy is complete"
    value       = null_resource.calico.id
}

##############################################################################