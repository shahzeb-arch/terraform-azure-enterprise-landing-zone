output "network_interface_ids" {
  description = "Map of network interface IDs."
  value       = { for k, m in module.network_interface : k => m.id }
}

output "linux_virtual_machine_ids" {
  description = "Map of Linux virtual machine IDs."
  value       = { for k, m in module.linux_virtual_machine : k => m.id }
}

output "windows_virtual_machine_ids" {
  description = "Map of Windows virtual machine IDs."
  value       = { for k, m in module.windows_virtual_machine : k => m.id }
}

output "linux_vmss_ids" {
  description = "Map of Linux VMSS IDs."
  value       = { for k, m in module.linux_vmss : k => m.id }
}
