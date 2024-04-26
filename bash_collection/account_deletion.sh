#!/bin/bash
#Obtain the correct user account name
#Kill any processes currently running belong to the account
#Determine all files belonging to the account
#Remove the user account

#Script for automate the 4 steps

#Function
function get_answer {

unset answer
ask_count=0

while [ -z "$answer" ] 
do
	ask_count=$[ $ask_count + 1 ]

	case $ask_count in
	2)
		echo
		echo "Please answer the question."
		echo
	;;
	3)
		echo
		echo "One last try... please answer."
		echo
	;;
	4)
		echo
		echo "EXITING PROGRAM"
		echo

		exit
	;;
        esac

	if [ -n "$line2" ]
	then
		echo $line1
		echo -e $line2" \c"
	else
		echo -e $line1" \c"
	fi

#Allow 60 seconds to answer
	read -t 60 answer 
done
#Variable clean-up
unset line1
unset line2

}
########################################
function process_answer {

answer=$(echo $answer | cut -c1)

case $answer in 
y|Y)
;;
*)

#If the user answer anything but yes
	echo
	echo $exit_line1
	echo $exit_line2
	echo
	exit
;;
esac

#Variable clean-up

unset exit_line1
unset exit_line2

} #End Process

#######################################3
##########MAIN SCRIPT###################

echo "step #1 - Determine User Account name to Delete "
echo
line1="Please anter the username of the user"
line2="account you wish to delete from system:"
get_answer
user_account=$answer
#Double check
line1="Is $user_account the user account "
line2="you wish to delete? [y/n]"
get_answer

#Function  call process_answer
exit_line1="Because the account, $user_account, is not "
exit_line2="the one you wish to delete, leaveing the script..."
process_answer

##################################################
#Check thaht the user really exist
user_account_record=$(cat /etc/passwd | grep -w $user_account)

if [ $? -eq 1 ]
then
	echo
	echo "Account, $user_account, not found. "
	echo "Leaving the script..."
	echo
	exit
fi

echo
echo "I found this record:"
echo $user_account_record
echo

line1="is this the correct user account? [y/n]"
get_answer

####################################################3
#Call process-answer_function

exit_line1="Because the account, $user_account. is not "
exit_line2="the one you wish to delete, leaving..."
process_answer

#####################################################
#Search for running process belonging to account

echo
echo "Step #2 - Find process "
echo

ps -u $user_account > /dev/null

case $? in
1)

	echo "There are no processes for this account
currently running"
	echo
;;
0)
	echo "$user_account has the following process running: "
	ps -u $user_account

	line1="Would you like me to kill the process? [y/n]"
	get_answer

	answer=$(echo $answer | cut -cl)

	case $answer in 
	y|Y)
		
		echo
		echo "Killing process..."
		command_1="ps -u $user_account --no-heading"
		command_3="xargs -d \\n /usr/bin/sudo /bin/kill -9"
		$command_1 | gawk '{print $1}' | $command_3
		echo
		eccho "Process killed."
	;;
	*)
	;;
	esac
;;
esac
#########################################################3
#Create a report of all files owned by the user account

echo 
echo "Step3" - Find files belonging to user account 
echo 
echo "Creating a report of all files owned by $user_account."
echo 
echo "It is recomended that you backup/archive these files,"
echo " and the do one of two things:"
echo "  1) Delete the files"
echo "  2) Change the files' ownership to a current user account."
echo
echo "Please wait. This may take a while..."

report_date=$(date +%y%m%d)
report_file="$user_account"_Files_"$report_date".rpt 

find / -user $user_account > $report_file 2>/dev/null

echo 
echo "Report is complete."
echo "Name of report:       $report_file"
echo -n "Location of report: "; pdw 
echo
############################################################
# Remove User Account
echo 
echo "Step #4 - Remove user account"
echo 

line1="Do you wish to remove $user_account's account from the system? [y/n]"
get_answer

#Call process_answer function:
exit_line1="Since you do not wish to remove the user account,"
exit_line2="$user_account at this time, exiting the script..."
process_answer

userdel $user_account
echo 
echo "User account, $user_account, has been removed"
echo 

exit 
$
