terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "default" {
  name = "default"
  type = "dir"
  path = "/var/lib/libvirt/images"
}

resource "libvirt_network" "gfs2_net" {
  name      = "gfs2-network"
  mode      = "nat"
  domain    = "gfs2.local"
  addresses = ["192.168.124.0/24"]
  dhcp {
    enabled = true
  }
}

resource "libvirt_volume" "ubuntu_image" {
  name   = "ubuntu-26.04-gfs2.img"
  pool   = libvirt_pool.default.name
  format = "qcow2"
}

resource "libvirt_volume" "iscsi_disk" {
  name           = "iscsi-target-disk.qcow2"
  base_volume_id = libvirt_volume.ubuntu_image.id
  pool           = libvirt_pool.default.name
  size           = 21474836480
}

resource "libvirt_volume" "iscsi_shared_disk" {
  name   = "iscsi-shared-storage.qcow2"
  pool   = libvirt_pool.default.name
  size   = 5368709120
  format = "qcow2"
}

resource "libvirt_domain" "iscsi_target" {
  name   = "iscsi-target"
  memory = 1024
  vcpu   = 1
  network_interface {
    network_name = libvirt_network.gfs2_net.name
  }
  disk {
    volume_id = libvirt_volume.iscsi_disk.id
  }
  disk {
    volume_id = libvirt_volume.iscsi_shared_disk.id
  }
  disk {
    file = "/var/lib/libvirt/images/iscsi-target-init.iso"
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

resource "libvirt_volume" "gfs2_disk" {
  count           = 3
  name            = "gfs2-node-${count.index + 1}-disk.qcow2"
  base_volume_id  = libvirt_volume.ubuntu_image.id
  pool            = libvirt_pool.default.name
  size            = 21474836480
}

resource "libvirt_domain" "gfs2_nodes" {
  count  = 3
  name   = "gfs2-node-${count.index + 1}"
  memory = 1024
  vcpu   = 1
  network_interface {
    network_name = libvirt_network.gfs2_net.name
  }
  disk {
    volume_id = libvirt_volume.gfs2_disk[count.index].id
  }
  disk {
    file = "/var/lib/libvirt/images/gfs2-node-${count.index + 1}-init.iso"
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
