#!/bin/bash

# ./lab4-check.bash

# Author:  Murray Saul
# Date:    June 7, 2016
#
# Purpose: Check that students correctly managed user and group accounts
#          when performing this lab, check that students have properly
#          managed services, and created a shell script to work like
#          a Linux command to automate creation of multiple user
#          accounts (user data stored in a text-file).

# Function to indicate OK (in green) if check is true; otherwise, indicate
# WARNING (in red) if check is false and end with false exit status

function check(){

  if eval $1
  then
     echo -e "\e[0;32mOK\e[m"
  else
     echo
     echo
     echo -e "\e[0;31mWARNING\e[m"
     echo
     echo
     echo $2
     echo
     exit 1
  fi

} # end of check() function

clear  # Clear the screen

# Make certain user is logged in as root
if [ $USER != "root" ]
then
  echo "Note: You are required to run this program as root."
  exit 1
fi

cat <<+
ATTENTION:

In order to run this shell script, please
have the following information ready:

 - IPADDRESSES for only your centos1 VM.

 - Your regular username password for centos1 VM.
   You were instructed to have the IDENTICAL usernames
   and passwords for ALL of these Linux servers. If not
   login into each VM, switch to root, and use the commands:

   useradd -m [regular username]
   passwd [regular username]

   Before proceeding.

After reading the above steps, press ENTER to continue
+
read null
clear


# Start checking lab4
echo
echo "CHECKING YOUR LAB4 WORK:"
echo

# Check ops235_2 user created (centos1)
echo "Checking that ops235_2 user created (centos1): "
read -p "Enter your centos1 username: " centos1UserName
read -p "Enter IP Address for your centos1 VMs eth0 device: " centos1_IPADDR
check "ssh $centos1UserName@$centos1_IPADDR \"grep -isq \"ops235_2\" /etc/passwd\"" "This program did NOT detect the user \"ops235_2\" in the \"/etc/passwd\" file. Please create this user, complete this lab, and re-run this checking script."

# Check ops235_1 user removed (centos1)
#echo -n "Checking that ops235_1 user removed: "
#check "! ssh $centos1UserName@$centos1_IPADDR grep -isq \"ops235_2\" /etc/passwd" "This program detected the user \"ops235_1\" in the \"/etc/passwd\" file, when that user should have been removed. Please remove this user, complete this lab, and re-run this checking script."

# Check foo created in /etc/skel directory (centos1)
echo "Checking that \"/etc/skel\" directory contains the file called \"foo\" (centos1):"
check "ssh $centos1UserName@$centos1_IPADDR ls /etc/skel | grep -isq \"foo\"" "This program did NOT detect the file called \"foo\" in the \"/etc/skel\" directory. Please create this file, remove the user ops235_2, and then create that user to see the \"foo\" file automatically created in that user's home directory upon the creation of this user. Complete this lab, and re-run this checking script."

# Check group name ops235 created with name "welcome" (centos1)
echo "Checking that a group name \"welcome\" is contained in the file \"/etc/group\": "
check "ssh $centos1UserName@$centos1_IPADDR grep -isq \"welcome\" /etc/group" "This program did NOT detect the group name \"welcome\" in the \"/etc/group\" file. Please remove the group, and correctly add the group with the correct GID, complete the lab (with secondary users added), and re-run this checking script."

# Check user noobie removed
echo "Checking that \"noobie\" user was removed: "
check "ssh $centos1UserName@$centos1_IPADDR ! grep -isq \"noobie\" /etc/passwd" "This program did NOT detect the user name \"noobie\" was removed. Remove this user account, and re-run this checking script."

# Check iptables service started and enabled (centos1)
echo "Checking that iptables service started and enabled (centos1): "
check "ssh $centos1UserName@$centos1_IPADDR systemctl status iptables | grep -iqs \"active\" && ssh $centos1UserName@$centos1_IPADDR systemctl status iptables | grep -iqs \"enabled\"" "This program did NOT detect that the iptables service has \"started\" and/or is \"enabled\". Use the systemctl to stopa and disable the iptables service, and re-run this checking script."

# Check  runlevel 5 for centos1 VM
echo "Checking that that \"centos1\" VM is in run-level 5: "
check "ssh $centos1UserName@$centos1_IPADDR /sbin/runlevel | grep -isq \"5$\"" "This program did NOT detect that your \"centos1\" VM is in runlevel 5. Please make certain you set the runlevel to 5 (Graphical mode with networking), and re-run this checking script."

# Check for file: /root/bin/createUsers.bash (c7host)
echo  "Checking that the script \"/root/bin/createUsers.bash\" exists: "
check "test -f /root/bin/createUsers.bash" "This program did NOT detect the file \"/root/bin/createUsers.bash\" on your \"c7host\" machine. Download, set execute permissions, and run this shell script, and re-run this checking script."

# Check that script createUsers.bash as run (c7host)
echo  "Checking that the script \"/root/bin/createUsers.bash\" was run: "
check "egrep -isq \"(msaul|dward|eweaver|sapted)\" /etc/passwd" "This program did NOT detect the new users (msaul, dward, eweaver, or sapted) in the \"/etc/passwd\" directory on your \"c7host\" VM. Make certain to run this shell script (and download the database file), and run this shell script, and re-run this checking script."


echo
echo
echo "Congratulations!"
echo
echo "You have completed your lab4. Please check SIGN-OFF section"
echo "To setup your terminals and command output, etc. to show your"
echo "OPS235 instructor for SIGN-OFF."
echo
