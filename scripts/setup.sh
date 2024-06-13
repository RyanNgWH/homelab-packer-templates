#!/bin/bash

# Install base packages
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y sudo cloud-init