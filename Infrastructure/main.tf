data "vsphere_datacenter" "datacenter" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = var.hard_disk
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "MTYN" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_vm_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "worker" {
  count            = var.worker_vm_count
  name             = "worker-${count.index}"
  resource_pool_id = data.vsphere_compute_cluster.MTYN.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.worker_num_cpus
  memory   = var.worker_memory

  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label = "disk0"
    size  = var.worker_hard_disk_size
    #size = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "worker-${count.index}"
        domain    = var.domain

      }
      network_interface {
        ipv4_address = "192.168.7.24${count.index}" # change it with your desired ip range
        ipv4_netmask = 24
      }
      ipv4_gateway    = var.ipv4_gateway
      dns_server_list = ["178.22.122.100", "185.51.200.2"] # DNS shecan , change it with your desired dns
    }
  }
}

resource "vsphere_virtual_machine" "control-plane" {
  count            = var.control_plane_vm_count
  name             = "control-plane-${count.index}"
  resource_pool_id = data.vsphere_compute_cluster.MTYN.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.control_plane_num_cpus
  memory   = var.control_plane_memory

  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label = "disk0"
    size  = var.control_plane_hard_disk_size
    #size = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "control-plane-${count.index}"
        domain    = var.domain

      }
      network_interface {
        ipv4_address = "192.168.7.23${count.index}" # change it with your desired ip range
        ipv4_netmask = 24
      }
      ipv4_gateway    = var.ipv4_gateway
      dns_server_list = ["178.22.122.100", "185.51.200.2"] # DNS shecan , change it with your desired dns
    }
  }
}




resource "time_sleep" "wait_1min" {                        # wait 3 min for vmtools on esxi
   depends_on = [
    
    vsphere_virtual_machine.worker,
    vsphere_virtual_machine.control-plane
  ]

   create_duration = "3m"
}





# Ensure VMs are provisioned first
resource "null_resource" "generate_ansible_inventory" {
  provisioner "local-exec" {
    command = "./generate_ansible_inventory.sh"
  }

  depends_on = [time_sleep.wait_1min]
}

# Run the Ansible playbook after the inventory is generated
resource "null_resource" "run_ansible" {
  provisioner "local-exec" {
    command = "ansible-playbook -i hosts.ini ./ansible-kubeadm/kubeadm.yml"
  }

  depends_on = [
    null_resource.generate_ansible_inventory
  ]
}
