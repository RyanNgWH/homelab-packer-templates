# Proxmox Debian 13
# ---
# Variables for creating a Debian 13 template on Proxmox

# Proxmox connection
variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
	type = string
  sensitive = true
}

# VM configuration
variable "proxmox_node" {
  type = string
}

variable "vm_name" {
  type = string
  default = "debian"
}

variable "vm_id" {
  type = number
  default = 99999
}

# CPU configuration
variable "vm_cpu_type" {
  type = string
  default = "host"
}

variable "vm_cpu_cores" {
  type = number
  default = 1
}

variable "vm_cpu_sockets" {
  type = number
  default = 1
}

variable "vm_cpu_numa" {
  type = bool
  default = true
}

# Memory configuration
variable "vm_memory_size" {
  type = number
  default = 1024
}

variable "vm_memory_ballooning_min" {
  type = number
  default = 1024
}

# OS configuration
variable "installer_iso_url" {
  type = string
}

variable "installer_iso_checksum" {
  type = string
}

variable "installer_storage_pool" {
  type = string
  default = "local"
}

variable "installer_unmount_iso" {
  type = bool
  default = true
}

variable "os_type" {
  type = string
  default = "l26"

  validation {
    condition = var.os_type == "wxp" || var.os_type == "w2k" || var.os_type == "w2k3" || var.os_type == "w2k8" || var.os_type == "wvista" || var.os_type == "win7" || var.os_type == "win8" || var.os_type == "win10" || var.os_type == "l24" || var.os_type == "l26" || var.os_type == "solaris" || var.os_type == "other"

    error_message = "The os_type variable can only be `wxp`, `w2k`, `w2k3`, `w2k8`, `wvista`, `win7`, `win8`, `win10`, `l24` (Linux 2.4), `l26` (Linux 2.6+), `solaris` or `other`."
  }
}

# System configuration
variable "system_bios" {
  type = string
  default = "ovmf"
}

variable "system_efi_storage" {
  type = string
  default = "local-zfs"
}

variable "system_pre_enroll_keys" {
  type = bool
  default = true
}

variable "system_efi_type" {
  type = string
  default = "4m"

  validation {
    condition = var.system_efi_type == "2m" || var.system_efi_type == "4m"

    error_message = "The system_efi_type can only have the value `2m` or `4m`."
  }
}

variable "system_machine_type" {
  type = string
  default = "q35"

  validation {
    condition = var.system_machine_type == "pc" || var.system_machine_type == "q35"

    error_message = "The system_machine type can only be `pc` or `q35`."
  }
}

variable "system_display_type" {
  type = string
  default = "std"

  validation {
    condition = var.system_display_type == "cirrus" || var.system_display_type == "none" || var.system_display_type == "qxl" || var.system_display_type == "qxl2" || var.system_display_type == "qxl3" || var.system_display_type == "qxl4" || var.system_display_type == "serial0" || var.system_display_type == "serial1" || var.system_display_type == "serial2" || var.system_display_type == "serial3" || var.system_display_type == "std" || var.system_display_type == "virtio" || var.system_display_type == "vmware"

    error_message = "The system_display_type variable can only be `cirrus`, `none`, `qxl`, `qxl2`, `qxl3`, `qxl4`, `serial0`, `serial1`, `serial2`, `serial3`, `std`, `virtio` or `vmware`."
  }
}

variable "system_qemu_agent" {
  type = bool
  default = true
}

# Network configuration
variable "network_model" {
  type = string
  default = "virtio"

  validation {
    condition = var.network_model == "rtl8139" || var.network_model == "ne2k_pci" || var.network_model == "e1000" || var.network_model == "pcnet" || var.network_model == "virtio" || var.network_model == "ne2k_isa" || var.network_model == "i82551" || var.network_model == "i82557b" || var.network_model == "i82559er" || var.network_model == "vmxnet3" || var.network_model == "e1000-82540em" || var.network_model == "e1000-82544gc" || var.network_model == "e1000-82545em"

    error_message = "The network_model variable can only be `rtl8139`, `ne2k_pci`, `e1000`, `pcnet`, `virtio`, `ne2k_isa`, `i82551`, `i82557b`, `i82559er`, `vmxnet3`, `e1000-82540em`, `e1000-82544gc` or `e1000-82545em`."
  }
}

variable "network_packet_queues" {
  type = number
  default = 1
}

variable "network_bridge" {
  type = string
  default = "vmbr0"
}

variable "network_vlan_tag" {
  type = string
  default = "20"
}

variable "network_firewall_enabled" {
  type = bool
  default = true
}

# Disk configuration
variable "storage_type" {
  type = string
  default = "scsi"
}

variable "storage_pool" {
  type = string
  default = "local-zfs"
}

variable "storage_size" {
  type = string
  default = "8G"
}

variable "storage_cache_mode" {
  type = string
  default = "none"
}

variable "storage_io_thread" {
  type = bool
  default = true
}

variable "storage_discard" {
  type = bool
  default = true
}

variable "storage_emulate_ssd" {
  type = bool
  default = true
}

variable "storage_scsi_controller" {
  type = string
  default = "virtio-scsi-single"

  validation {
    condition = var.storage_scsi_controller == "lsi" || var.storage_scsi_controller == "lsi53c810" || var.storage_scsi_controller == "virtio-scsi-pci" || var.storage_scsi_controller == "virtio-scsi-single" || var.storage_scsi_controller == "megasas" || var.storage_scsi_controller == "pvscsi"

    error_message = "The storage_scsi_controller message can only be `lsi`, `lsi53c810`, `virtio-scsi-pci`, `virtio-scsi-single`, `megasas` or `pvscsi`."
  }
}

# Template configuration
variable "template_name" {
  type = string
  default = "debian-template"
}

variable "template_description" {
  type = string
  default = "Debian VM template"
}

variable "template_cloud_init" {
  type = bool
  default = true
}

variable "template_cloud_init_storage_pool" {
  type = string
  default = "local-zfs"
}

# Boot commmand
variable "boot_command" {
  type = list(string)
}

variable "boot_wait_time" {
  type = string
  default = "10s"
}

# HTTP directory configuration
variable "http_port_min" {
  type = number
  default = 8080
}

variable "http_port_max" {
  type = number
  default = 8080
}

# SSH configuration for provisioner
variable "provisioner_ssh_username" {
  type = string
}

variable "provisioner_ssh_private_key_file" {
  type = string
}

variable "provisioner_ssh_timeout" {
  type = string
  default = "10m"
}