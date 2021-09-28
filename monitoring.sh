#!/bin/bash
wall \
"#Architecture: $(uname -a)
#CPU physical: $(lscpu -b -p=Socket | grep -v '^#' | sort -u | wc -l)
#vCPU: $(nproc)
#Memory Usage: $(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)", $3, $2, $3*100/$2}') 
#Disk Usage: $(df -h --total | awk '$NF=="-"{printf "%d/%dGb (%s)", $3, $2, $5}')
#CPU load: $(top -b -n2 | grep Cpu | awk 'END{print 100-$8;}')%
#Last boot: $(who -b | cut -c 23-)
#LVM use: $(if [ $(lsblk | grep "lvm" | wc -l) == 0 ]; then echo no; else echo yes; fi)
#Connections TCP: $(ss -neopt state established | sed -e 1d | wc -l) ESTABLISHED
#User log: $(users | wc -w)
#Network: IP $(ip route get 1.2.3.4 | awk '{printf $7}') ($(ip a | grep ether | cut -d " " -f6))
#Sudo: $(ls -l /var/log/sudo/ | grep -c ^d) cmd"
