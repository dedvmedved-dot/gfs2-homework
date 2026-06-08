output "iscsi_target_ip" {
  description = "IP-адрес iSCSI target"
  value       = "192.168.124.10"
}

output "gfs2_nodes_ips" {
  description = "IP-адреса GFS2 узлов"
  value       = ["192.168.124.21", "192.168.124.22", "192.168.124.23"]
}

output "vm_names" {
  description = "Имена всех ВМ"
  value = concat(
    [libvirt_domain.iscsi_target.name],
    libvirt_domain.gfs2_nodes[*].name
  )
}
