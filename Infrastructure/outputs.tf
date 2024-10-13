# Output the worker IPs
output "worker_ips" {
  value = [
    for vm in vsphere_virtual_machine.worker : vm.network_interface[0].ipv4_address
  ]
}

# Output the control-plane IPs
output "control_plane_ips" {
  value = [
    for vm in vsphere_virtual_machine.control-plane : vm.network_interface[0].ipv4_address
  ]
}
