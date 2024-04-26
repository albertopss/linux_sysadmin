#!/bin/bash
#Commands for managing process
########ulimit - displays or resets process resource limits restrict or expand
#only affect current shell, ¬¬/etc/security/limits.conf
#jobs show background processes
#########at executes any non-interactive command at specified time
#at now + 2 days
#########cron
#Used for any job thaht needs to run on a regular schedule
#to run every hour, day, once or every
#/etc/anacrontab
########sleep, used as reminder
#(sleep 600; script.sh) &
######DAEMONS
######NICE to set priorities
#Lower nice value raise the priority & viceverse
#Renice 

###########Process Monitoring################
#top, uptime, ps aux -elf -eL -C "bash" -o
 pstree -aAp,  mpstat, iostat, sar, numastat, strace
#top
#The virtual /proc fylesystem can be helpful in monitoring.
#Some distros use cockpit 

