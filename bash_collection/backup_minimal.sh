#!/bin/bash
#Simple back up script
#Change the TAPE device to match your system
#Check /var/log/messages to determine your tape device
TAPE=/dev/rft0
#]Rewind the tape device $TAPE
mt $TAPE rew
#Get a list of home directories
HOMES= `grep /home /etc/passwd | cut -f6 -d' : ' `
#Backup the data in those directories
tar cvf $TAPE $HOMES
#Rewind and eject the tape
mt $TAPE rewoffl

