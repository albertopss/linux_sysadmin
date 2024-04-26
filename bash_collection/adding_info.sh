#/bin/bash
#Adding users an info to text file
#A very simple telephone list
#Options add or search
PHONELIST=~/.phonelist.txt

#Command line parameters ($#)
if [ $# -lt 1 ] ; then
shift
echo "Whose phone number did you want? "
	exit1
fi

#Did you want to add new phone number?
if [ $1 = "new" ] ; then
shift
echo $* >> $PHONELIST
echo $* added to database
exit 0
fi

#First time using it
if [ ! -s $PHONELIST ] ; then
	echo "No names in the phone list yet! "
	exit 1
else
	grep -i -q "$*" $PHONELIST
	if [ $? -ne 0 ] ; then
		echo "Sorry, that name was not found in the phone list"
		exit 1
	else
		grep -i "$*" $PHONELIST
	fi
fi
exit 0
 