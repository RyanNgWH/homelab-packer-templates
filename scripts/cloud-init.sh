#!/bin/bash

# Cleanup cloud-init for golden template
cloud-init clean
truncate -s 0 /etc/machine-id