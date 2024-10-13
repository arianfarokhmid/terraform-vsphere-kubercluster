############### genearl configs #############

vsphere_user            = "terraform@vsphere.local"
vsphere_password        = "---"
vsphere_server          = "192.168.7.12"
resource_name           = "test"
ipv4_gateway            = "192.168.7.1"
domain                  = "kuber-cluster"
hard_disk               = "HDD-10K-R5"
template_vm_name        = "Ubuntu-with-Docker-TMP" # change it with your tempalte name
vsphere_compute_cluster = "MTYN" # your compute cluster name
vsphere_network         = "VM Network" 

############### worker ######################

worker_vm_count                = 3
worker_num_cpus                = 8
worker_memory                  = 8192
worker_vm_ips                  = "192.168.7.240"
worker_hard_disk_size          = 60

############# control-plane #################

control_plane_vm_count                = 3
control_plane_num_cpus                = 8
control_plane_memory                  = 8192
control_plane_vm_ips                  = "192.168.7.240"
control_plane_hard_disk_size          = 60