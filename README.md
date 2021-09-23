![Rigor](https://img.shields.io/badge/Rigor-306998) ![Network&SystemAdministration](https://img.shields.io/badge/Network&SystemAdministration-306998)

# Born2beroot :computer:
A System Administration exercise. Setting up my first server by following specific rules.

- [About Debian](https://github.com/denisgodoy/42-born2beroot#about-debian)
- [What is a Virtual Machine](https://github.com/denisgodoy/42-born2beroot#mandatory-part)
- [Setting up a server](https://github.com/denisgodoy/42-born2beroot#bonus-part)
- [Useful commands](https://github.com/denisgodoy/42-born2beroot#bonus-part)

## About Debian
Debian is an open-source OS well known for its `apt` package manager, with over 59.000 software packages, and supporting a long list of compatible CPU architectures.

## What is a Virtual Machine
A Virtual Machine (VM) is a virtual environment with its own CPU, memory, network interface and disk space. This virtual system, called *guest machine*, is created from an existing physical hardware, known as *host machine*. The virtualization technology (hypervisor) allows sharing a system with multiple virtual environments. Oracle VirtualBox is a Type 2 hypervisor.

## Setting up a server
Proceed with a minimum install of Debian 11 on VirtualBox, downloading the image for the latest stable version. Any graphical interface is therefore forbidden.

Create the necessary partion for `/boot` and a new encrypted volume group. This volume group will then be splitted in (for mandatory part): `/`, `/swap`and `/home`.

Run the OS as root and install the mandatory sofware packages.

```shell
apt-get update
apt-get install sudo ufw vim openssh-server libpam-pwquality apparmor cron
```

## Useful commands
#### Users and groups
```shell
adduser <username> #add a new user
usermod -aG <groupname> <username> #add user to an existing group
groups <username> #check if user belongs to any groups
groupadd <groupname> #add a new group
passwd <username> #change user password
```

#### Hostname
```shell
hostnamectl set-hostname <hostname> #change the hostname
vim /etc/hosts #edit the file replacing the old name
hostnamectl status #check the changes after reboot
```

#### Partitions
```shell
lsblk #show partitions
```

#### Sudo
```shell
sudo -V #check if it's installed
cd /var/log/sudo/ #check log files
```

#### UFW
```shell
ufw status #check if it's installed and active
ufw status numbered #check current active rules
ufw allow <port> #add a new rule to open port
ufw delete allow <port> #remove v4 and v6 rules
```

#### SSH
```shell
systemctl status ssh #check if it's installed and active
ss -tunlp #check socket statistics
ssh <username>@<ip address> -p <port> #remotely connect to the server
cd /etc/ssh && vim sshd_config #modify the file to open or close a port
```

#### Cron
```shell
systemctl stop cron #stop showing script
systemctl disable cron #disable cron
systemctl enable cron #enable cron
systemctl start cron #start showing script
```
