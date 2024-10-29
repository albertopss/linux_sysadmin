#!/bin/bash

DATE=$(date '+%F' )

if [[ ${UID} -eq 0 ]]
then
	cowsay -f meow "Creating the backup..."
	sudo rsync -avz /home/alberto/shellclass/exercises alberto@localhost:/home/alberto/back_test/$DATE
	echo 
	echo
	echo "Backup done."
	exit 1
else
	cowsay -f sodomized "Hmmmmm run like root"
	exit 1
fi


