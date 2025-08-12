# Proxmox Debian 13
# ---
# Packer template for creating a Debian 13 template on Proxmox

# Plugin
packer {
  required_plugins {
    name = {
      version = "~> 1"
      source = "github.com/hashicorp/proxmox"
    }
  }
}

# Local variables
locals {
  packer_timestamp = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
}

# Resource definition for the VM template
# Refer to https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/iso for all available options
source "proxmox-iso" "debian-13" {
  # Proxmox connection
  proxmox_url = "${var.proxmox_api_url}"
  username = "${var.proxmox_api_token_id}"
  token = "${var.proxmox_api_token_secret}"

  # VM configuration
  node = "${var.proxmox_node}"
  vm_name = "${var.vm_name}"
  vm_id = "${var.vm_id}"
  tags = "packer"

  # CPU configuration
  cpu_type = "${var.vm_cpu_type}"
  cores = "${var.vm_cpu_cores}"
  sockets = "${var.vm_cpu_sockets}"
  numa = "${var.vm_cpu_numa}"

  # Memory configuration
  memory = "${var.vm_memory_size}"
  ballooning_minimum = "${var.vm_memory_ballooning_min}"

  # OS configuration
  boot_iso {
    iso_url = "${var.installer_iso_url}"
    iso_checksum = "${var.installer_iso_checksum}"
    iso_storage_pool = "${var.installer_storage_pool}"

    unmount = "${var.installer_unmount_iso}"
  }

  os = "${var.os_type}"

  # System configuration
  bios = "${var.system_bios}"

  efi_config {
    efi_storage_pool = "${var.system_efi_storage}"
    pre_enrolled_keys = "${var.system_pre_enroll_keys}"
    efi_type = "${var.system_efi_type}"
  }

  machine = "${var.system_machine_type}"

  vga {
    type = "${var.system_display_type}"
  }

  qemu_agent = "${var.system_qemu_agent}"

  # Network configuration
  network_adapters {
    model = "${var.network_model}"
    packet_queues = "${var.network_packet_queues}"
    bridge = "${var.network_bridge}"
    vlan_tag = "${var.network_vlan_tag}"
    firewall = "${var.network_firewall_enabled}"
  }

  # Disk configuration
  disks {
    type = "${var.storage_type}"
    storage_pool = "${var.storage_pool}"
    disk_size = "${var.storage_size}"
    cache_mode = "${var.storage_cache_mode}"
    io_thread = "${var.storage_io_thread}"
    discard = "${var.storage_discard}"
    ssd = "${var.storage_emulate_ssd}"
  }
  scsi_controller = "${var.storage_scsi_controller}"

  # Template configuration
  template_name = "${var.template_name}"
  template_description = "[Packer] ${var.template_description}\n\nCreated on: ${local.packer_timestamp} "

  cloud_init = "${var.template_cloud_init}"
  cloud_init_storage_pool = "${var.template_cloud_init_storage_pool}"

  # Boot command
  boot_command = var.boot_command
  boot_wait = "${var.boot_wait_time}"

  # HTTP directory configuration (for serving the preseed file)
  http_directory = "http"
  http_port_min = "${var.http_port_min}"
  http_port_max = "${var.http_port_max}"


  # SSH configuration for provisioner
  ssh_username = "${var.provisioner_ssh_username}"
  ssh_private_key_file = "${var.provisioner_ssh_private_key_file}"
  ssh_timeout = "${var.provisioner_ssh_timeout}"
}

# Build the VM Template
build {
  name = "proxmox-debian-13"
  sources = ["source.proxmox-iso.debian-13"]

  # Setup the VM Template
  provisioner "shell" {
    script = "scripts/setup.sh"
  }

  # Copy cloud-init pve configuration file to VM Template
  provisioner "file" {
    source = "files/99_pve.cfg"
    destination = "/etc/cloud/cloud.cfg.d/99_pve.cfg"
  }

  # Copy cloud-init default user configuration file to VM Template
  provisioner "file" {
    source = "files/50_default_user.cfg"
    destination = "/etc/cloud/cloud.cfg.d/50_default_user.cfg"
  }

  # Configure cloud-init
  provisioner "shell" {
    script = "scripts/cloud-init.sh"
  }

  # Cleanup VM template
  provisioner "shell" {
    script = "scripts/cleanup.sh"
  }
}
