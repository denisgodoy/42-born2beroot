#!/bin/bash

echo -e "Broadcast message from root@$HOSTNAME ($(ps -p $$ -o tty=)) ($(date +"%a %b %d %H:%M:%S %Y")):\n
#Architecture: $(uname -a)
#CPU physical: $(lscpu -b -p=Socket | grep -v '^#' | sort -u | wc -l)
#vCPU $(nproc)
#Memory Usage: $(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)", $3, $2, $3*100/$2}') 
#Disk Usage: $(df -h --total | awk '$NF=="-"{printf "%d/%dGb (%s)", $3, $2, $5}')
#CPU load:
#Last boot: $(who -b | cut -c 23-)
#LVM use:
#Connections TCP: $(ss -neopt state established | sed -e 1d | wc -l) ESTABLISHED
#User log: $(users | wc -w)
#Network: IP $(ip route get 1.2.3.4 | awk '{printf $7}') ($(ip a | grep ether | cut -d " " -f6))
#Sudo: $(ls -l /var/log/sudo/ | grep -c ^d) cmd"
