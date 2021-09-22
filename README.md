![Rigor](https://img.shields.io/badge/Rigor-306998) ![Network&SystemAdministration](https://img.shields.io/badge/Network&SystemAdministration-306998)

# Born2beroot :computer:
A System Administration exercise. Setting up my first server by following specific rules.

## About Debian
Debian is an open-source OS well known for its `apt` package manager, with over 59.000 software packages, and supporting a long list of compatible CPU architectures.

## What is a Virtual Machine
A Virtual Machine (VM) is a virtual environment with its own CPU, memory, network interface and disk space. This virtual system, called *guest machine* is created from an existing physical hardware, also called *host machine*. The virtualization technology (hypervisor) allows sharing a system with multiple virtual environments. Oracle VirtualBox is a Type 2 hypervisor.

## Setting up a server
Proceed with a minimum install of Debian 11, downloading the image for the latest stable version. Any graphical interface is forbidden.

Configure the install on VirtualBox.

Create the necessary partion for `/boot` and a new encrypted volume group. This volume group will then be splitted in 3: `/`, `/swap`and `/home`.

As root, install the mandatory sofwares.

```shell
apt-get update
apt-get install sudo ufw vim openssh-server libpam-pwquality apparmor cron
```
