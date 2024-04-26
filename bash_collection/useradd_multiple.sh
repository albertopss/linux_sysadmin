#!/bin/bash
#Addusers from text file
input="users.csv"
while IFS=' , ' read -r logginname name
do
	echo "adding $loginname"
	useradd -c "$name" -m $loginname
done < "$input"
$

