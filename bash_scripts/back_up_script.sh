#!/bin/bash

# Daily_Archive - Archive designated files & directories
########################################################
#VARIABLES
#Gather Current Date
#
today=$(date +%y%m%d)
#
#Set Archive File Name
#
backupFile=archive$today.tar.gz
#
#Set Configuration and Destination File
#
config_file=/archive/Files_To_Backup.txt
destination=/archive/$backupfile
#
######MAIN SCRIPT######
#Check Backup config file exist
#
if [ -f $config_file ] 
then
	echo
else
	echo
	echo "$config_file does not exist."
	echo "Backup not completed due to missing Configuration Files"
	echo
	exit
fi
#
#Build the names of all the files to backup
#
file_no1=1
exec 0< $config_file
#
read file_name
#
while [ $? -eq 0 ] 
do
	if [ -f $file_name -o -d $file_name ]
	then
		file_list="$file_list $file_name"
	else
		echo
		echo "$file_name, does not exist. "
		echo
	fi

	file_no=$[$file_no + 1]
	read file_name
done
#
#####################
#
#Backup the files and compress archive
#
echo "Starting archive..."
echo
#
tar -cvf $destination $file_list 2> /dev/null
#
echo "Archive completed"
echo "Resulting archive file is: $destination"
echo
#
#exit
$
