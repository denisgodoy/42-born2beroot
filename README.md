![Rigor](https://img.shields.io/badge/Rigor-306998) ![Network&SystemAdministration](https://img.shields.io/badge/Network&SystemAdministration-306998)

# Born2beroot :computer:
A System Administration exercise. Setting up my first server by following specific rules.

- [Evaluation](https://github.com/denisgodoy/42-born2beroot#evaluation)
- [About Debian](https://github.com/denisgodoy/42-born2beroot#about-debian)
- [What is a Virtual Machine](https://github.com/denisgodoy/42-born2beroot#what-is-a-virtual-machine)
- [Mandatory part - set up a server](https://github.com/denisgodoy/42-born2beroot#mandatory-part---set-up-a-server)
- [Bonus part - set up partitions](https://github.com/denisgodoy/42-born2beroot#bonus-part---set-up-partitions)
- [Useful commands](https://github.com/denisgodoy/42-born2beroot#useful-commands)

## Evaluation
![Evaluation](https://user-images.githubusercontent.com/56933400/135363170-7f328f0b-04d2-44d6-abbf-650eed9f54ab.png)
![Badge](https://game.42sp.org.br/static/assets/achievements/born2beroote.png)

## About Debian
Debian is an open-source OS well known for its `apt` package manager, with over 59.000 software packages, and supporting a long list of compatible CPU architectures.

| Feature | CentOS | Debian |
|:-------:|:------:|:------:|
| Free/open-source | :heavy_check_mark: | :heavy_check_mark: |
| Not affiliated | | :heavy_check_mark: |
| Multiple architecture | | :heavy_check_mark: |
| Packages | | :heavy_check_mark: |
| Update frequency | | :heavy_check_mark: |
| Easy to upgrade | | :heavy_check_mark: |
| Market preference | :heavy_check_mark: | |

`apt` stands for Advanced Packaging Tool. It handles software installation and removal completely on the command line, unlike `aptitude`, which is a front-end packaging tool, adding an user interface to the functionality.

## What is a Virtual Machine
A Virtual Machine (VM) is a virtual environment with its own CPU, memory, network interface and disk space. This virtual system, also called *guest*, is created from an existing physical hardware, known as *host*. The virtualization technology (*hypervisor*) allows sharing a system with multiple virtual environments, partitioning from the rest of the system so the software inside a VM can't interfere with the host's OS.  Oracle VirtualBox is a Type 2 hypervisor, executed on the OS like a layer of software or application.

## Mandatory part - set up a server
Proceed with a minimum install of Debian 11 on VirtualBox, downloading the image for the latest stable version. Any graphical interface is therefore forbidden.

Create the necessary partion for `/boot` and a new encrypted volume group. This volume group will then be splitted in logical volumes (LVM): `/`, `/swap`and `/home`.

LVM are dynamic partitions that can be created, resized or deleted from the command line while the server is still running. No reboot is necessary to make the kernel aware of any changes. Specially useful with multiple disks.

Run the OS as root and install the mandatory sofware packages.

```shell
apt-get update
apt-get install sudo ufw vim openssh-server libpam-pwquality apparmor cron
```

Configure sudo and sudoers permissions, giving *superuser* privileges to commom users.
```shell
visudo #open and modify the file as it follows
Defaults  badpass_message="Wrong password. Try again." #create a default message for wrong password input
Defaults  passwd_tries=3 #max number of password retries
Defaults  iolog_dir="/var/log/sudo", iolog_file="%{user}-%{command}-%Y%d%H%M" #save sudo logs to a sudo directory
Defaults  logfile="/var/log/sudo/sudo.log" #create a log file from users sudo access
Defaults  log_input, log_output #save both input and output logs
Defaults  requiretty #TTY mode is required
```

Configure SSH client to allow remote connections, providing secure access authentication and encrypted data communications between two computers over the internet.
```shell
cd /etc/ssh && vim sshd_config #open and modify the file as it follows
Port <port> #uncomment and change port
PermitRootLogin no #uncomment line
```

Configure UFW - an easy-to-use IPv4/IPv6 host-based firewall. It blocks access from non-authorized connection ports.

Implement a strong password policy with PAM-pwquality.
```shell
cd /etc/security && vim pwquality.conf #open and modify the file as it follows
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
cd /etc && vim login.defs #open and modify the file as it follows
PASS_MAX_DAYS 30 #expire every 30 days
PASS_MIN_DAYS 2 #minimum number of days for password modification
PASS_WARN_AGE 7 #send a warning 7 days before it expires
```

Enable AppArmor, which is a Mandatory Access Control (MAC) security system that binds access control attributes to programs rather than to users. This helps keep the server safe, restricting actions processes can take, preventing applications from turning evil.

Enable Cron, an utility used to schedule commands for automatic execution at specific intervals. The `crontab` command creates a file with instructions for the cron daemon to execute.

## Bonus part - set up partitions
Set up the partitions correctly.

```
NAME                    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                       8:0    0   30G  0 disk  
├─sda1                    8:1    0  477M  0 part  /boot
├─sda2                    8:2    0    1K  0 part  
└─sda5                    8:5    0 29.5G  0 part  
  └─sda5_crypt          254:0    0 29.5G  0 crypt 
    ├─LVMGroup-root     254:1    0  9.5G  0 lvm   /
    ├─LVMGroup-swap     254:2    0  2.2G  0 lvm   [SWAP]
    ├─LVMGroup-home     254:3    0  4.8G  0 lvm   /home
    ├─LVMGroup-var      254:4    0  2.9G  0 lvm   /var
    ├─LVMGroup-srv      254:5    0  2.9G  0 lvm   /srv
    ├─LVMGroup-tmp      254:6    0  2.9G  0 lvm   /tmp
    └─LVMGroup-var--log 254:7    0  4.4G  0 lvm   /var/log
sr0                      11:0    1 1024M  0 rom   
```

## Useful commands
#### AppArmor
```shell
aa-status #check if it's installed
systemctl status apparmor #check its current status
```

#### Cron
```shell
crontab -e #open file and add new jobs
systemctl stop cron #stop showing script
systemctl disable cron #disable cron
systemctl enable cron #enable cron
systemctl start cron #start showing script
```

#### Hostname
```shell
hostnamectl set-hostname <hostname> #change the hostname
vim /etc/hosts #edit the file replacing the old name
hostnamectl status #check the changes after reboot
```

#### Operating system
```shell
head -n 2 /etc/os-release #check the OS
```

#### Partitions
```shell
lsblk #show partitions
```

#### SSH
```shell
systemctl status ssh #check if it's installed and active
ss -tunlp #check socket statistics
ssh <username>@<ip address> -p <port> #remotely connect to the server
cd /etc/ssh && vim sshd_config #modify the file to open or close a port
```

#### Sudo
```shell
visudo #open sudo configuration file
sudo -V #check if it's installed
cd /var/log/sudo/ #check log files
sudo update-alternatives --config editor #change default editor for visudo
```

#### UFW
```shell
ufw status #check if it's installed and active
ufw allow <port> #add a new rule to open port
ufw delete allow <port> #remove v4 and v6 rules
```

#### Users and groups
```shell
adduser <username> #add a new user
userdel <username> #delete an existing user
usermod -aG <groupname> <username> #add user to an existing group
groups <username> #check if user belongs to any groups
groupadd <groupname> #add a new group
deluser <username> <groupname> #remove user from a group
groupdel <groupname> #delete an existing group
passwd <username> #change user password
```
