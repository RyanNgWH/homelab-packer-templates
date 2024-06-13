# Proxmox Debian 12
# ---
# Packer variables for VM template on Proxmox
# Variable details can be found at https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/iso

# Required variables
# ---
# Proxmox connection
proxmox_api_url = "https://your-proxmox-server/api2/json"
proxmox_api_token_id = "packer@pve!packer"
proxmox_api_token_secret = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
proxmox_node = "your-proxmox-node"

# OS configuration
installer_iso_url = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso"
installer_iso_checksum = "sha512:33c08e56c83d13007e4a5511b9bf2c4926c4aa12fd5dd56d493c0653aecbab380988c5bf1671dbaea75c582827797d98c4a611f7fb2b131fbde2c677d5258ec9"

# Boot command
boot_command = [
  "<down><down><enter><down><down><down><down><down><wait>",
  "e<wait>",
  "<down><down><down><wait>",
  "<end><wait>",
  "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>",
  "fb=false <wait>",
  "debconf/frontend=noninteractive <wait>",
  "console-setup/ask_detect=false <wait>",
  "netcfg/disable_autoconfig=true <wait>",
  "netcfg/get_ipaddress=172.28.20.254/24 <wait>",
  "netcfg/get_gateway=172.28.20.1 <wait>",
  "netcfg/get_nameservers=172.28.20.1 <wait>",
  "<f10><wait>"]

# SSH configuration for provisioner
provisioner_ssh_username = "root"
provisioner_ssh_private_key_file = "/path/to/your/private/key"

# Optional variables (default values are specified below)
# ---
# VM configuration
vm_name = "debian-12-template"
vm_id = 99999

# CPU configuration
vm_cpu_type = "host"
vm_cpu_cores = 1
vm_cpu_sockets = 1
vm_cpu_numa = true

# Memory configuration
vm_memory_size = 1024
vm_memory_ballooning_min = 1024

# OS configuration
installer_storage_pool = "local"
installer_unmount_iso = true

os_type = "l26"

# System configuration
system_bios = "ovmf"

system_efi_storage = "local-lvm"
system_pre_enroll_keys = true
system_efi_type = "4m"

system_display_type = "std"

system_qemu_agent = true

# Network configuration
network_model = "virtio"
network_packet_queues = 1
network_bridge = "vmbr0"
network_vlan_tag = "20"
network_firewall_enabled = true

# Disk configuration
storage_type = "scsi"
storage_pool = "local-lvm"
storage_size = "8G"
storage_cache_mode = "none"
storage_io_thread = true
storage_discard = true
storage_emulate_ssd = true

storage_scsi_controller = "virtio-scsi-single"

# Template configuration
template_name = "debian-12-template"
template_description = "Debian 12 template"

template_cloud_init = true
template_cloud_init_storage_pool = "local-lvm"

# Boot command
boot_wait_time = "5s"

# HTTP directory configuration
http_port_min = 8080
http_port_max = 8080

# SSH configuration for provisioner
provisioner_ssh_timeout = "10m"