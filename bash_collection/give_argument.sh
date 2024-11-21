#!/bin/bash
if [[ "${#}" -lt 1 ]]
then
	echo "Bad usage, give one argument: $0 <argument>" 
	exit 99
fi
echo "Hello $1, welcome!" 


