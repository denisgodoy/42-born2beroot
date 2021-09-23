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

Configure sudo and sudoers permissions with `visudo`.
```shell
Defaults  badpass_message="Wrong password. Try again." #Create a default message for wrong password input
Defaults  passwd_tries=3 #Max number of password retries
Defaults  iolog_dir="/var/log/sudo", iolog_file="%{user}-%{command}-%Y%d%H%M" #Save sudo logs to a sudo directory
Defaults  logfile="/var/log/sudo/sudo.log" #Create a log file from users sudo access
Defaults  log_input, log_output #Save both input and output logs
Defaults  requiretty #TTY mode is required
```

Configure SSH client to allow remote connections.
```shell
cd /etc/ssh
vim sshd_config
Port 4242 #uncomment and change port
PermitRootLogin no #uncomment line
systemctl enable ssh #close the file and enable the service
systemctl start ssh #start ssh service
```

Configure UFW firewall to block access from other ports.
```shell
ufw delete allow <port> #delete existing rules
ufw allow 4242 #allow only port 4242
systemctl enable ufw #enable the service
systemctl start ufw #start the service
```

Enable AppArmor.
```shell
systemctl enable apparmor #enable the service
systemctl start apparmor #start the service
```

Implement a strong password policy with PAM-pwquality.
```shell
cd /etc/security
vim pwquality.conf #open file, uncomment and update the following lines
difok = 7 #number of repeated characters from previous password
minlen = 10 #minimum length
dcredit = -1 #at least one numeber
ucredit = -1 #at least one uppercase letter
maxrepeat = 3 #not more than 3 consecutive identical characters
usercheck = 1 #must not contain the username
enforce_for_root #root has to comply, even though they could bypass it
```

Configure expiring dates.
```shell
cd /etc
vim login.defs #open file and update the following lines
PASS_MAX_DAYS 30 #Expire every 30 days
PASS_MIN_DAYS 2 #Minimum number of days for password modification
PASS_WARN_AGE 7 #Send a warning 7 days before it expires
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
