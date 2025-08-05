<!-- @format -->

# Packer Proxmox Debian 12 Build

This project contains the Packer build configuration for Proxmox using a Debian 12 image.

It utilises the Packer `proxmox-iso` plugin which will create the VM on proxmox before sending a `boot-command` to the Debian installer to execute the automated install using the `preseed.cfg` configuration file.

> Packer temporaily sets up a HTTP server on the local system to deliver the `preseed.cfg` file to the Debian VM.
>
> As such, network configurations for the Debian VM has to be preseeded in `boot_command` instead of the `preseed.cfg` file.

# Requirements

## Local system

The following software must be installed on the local machine before Packer can be used to build the images.

- [Packer](https://www.packer.io/)

## Proxmox

An API token with the following permissions has to be created on your Proxmox instance. Stricter permissions might be possible but these templates have only been tested with the following proxmox privileges:

- Datastore.Allocate
- Datastore.AllocateSpace
- Datastore.AllocateTemplate
- Datastore.Audit
- SDN.Audit
- SDN.Use
- Sys.Audit
- VM.Allocate
- VM.Audit
- VM.Config.CDROM
- VM.Config.CPU
- VM.Config.Cloudinit
- VM.Config.Disk
- VM.Config.HWType
- VM.Config.Memory
- VM.Config.Network
- VM.Config.Options
- VM.Console
- VM.PowerMgmt

## Firewall

This build utilises a temporary local HTTP server to deliver the preseed file to the Debian installer.

Ensure that your firewall (local & network) allows the VM to pull the file from the local server.

The local HTTP server uses port `8080` by default. This can be changed by modifying the `http_port_min` and `http_port_max` variables in your `config.pkrvars.hcl` file.

# Usage

1. Create a copy of `example.config.pkrvars.hcl` (e.g `config.pkrvars.hcl`) and modify the variables as required.
1. Install all required plugins by initialising the directory with packer

```
packer init .
```

3. Run the following command to build the image

```
packer build --var-file=config.pkrvars.hcl .
```

> Replace `config.pkrvars.hcl` with your variables file

4. Upon completion, a VM template will be created in your proxmox instance. A default ansible user is available for all users for ansible provisioning. Edit `files/50_default_user.cfg` to modify the default user.

# Configuration

## Preseed

Update the default installation variable as desired. Some common variables include:

- `netcfg/get_hostname` - VM hostname
- `netcfg/get_domain` - VM network domain
- `passwd/root-password-crypted` - Root account password
- `clock-setup/ntp-server` - NTP server
- `preseed/late_command` - Replace with your root ssh key to allow packer to ssh into the VM (remember to update the packer ssh keyfile variable in `config.pkrvars.hcl` too)

## Packer

All variables used in the build image can be found in `example.config.pkrvars.hcl`. There are 2 types of variables (**required** & **optional**).

### Required variables

Located at the top of the file, these variables have to be manually populated as they do not have any default values.

### Optional variables

Located after the required variables, these variables are prepopulated with the default variables in `example.config.pkrvars.hcl`. To override the default values, simple replace the values in the file. Default values will be used if these variables are omitted.

# Limitations

## CPU flags & Qemu guest agent TRIM

These variables should be set but are not supported by the provider (as of `v1.1.8`). However, these can be automated using Opentofu and therefore, are not included in the usage instructions

## VirtIO RNG

`rng0` option is not working possibly due to a bug in the proxmox API. When specified, there is a `500 only root can set 'rng0' config` error even when using the `root@pam` api token.
