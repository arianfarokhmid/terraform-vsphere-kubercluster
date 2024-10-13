################## general vars ################

variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "hosts" {
  default = "host0"
}
variable "datacenter" {
  default = "Datacenter"
}

variable "resource_name" {}
variable "vsphere_compute_cluster" {}
variable "vsphere_network" {}
variable "template_vm_name" {}
variable "domain" {}
variable "ipv4_gateway" {}
variable "hard_disk" {}

##################### worker ###################

variable "worker_vm_count" {
  type = number
}
variable "worker_num_cpus" {
  type = number
}
variable "worker_memory" {
  type = number
}
variable "worker_vm_ips" {}

variable "worker_hard_disk_size" {
  type = number
}


################### control plane ##############

variable "control_plane_vm_count" {
  type = number
}
variable "control_plane_num_cpus" {
  type = number
}
variable "control_plane_memory" {
  type = number
}
variable "control_plane_vm_ips" {}

variable "control_plane_hard_disk_size" {
  type = number
}



