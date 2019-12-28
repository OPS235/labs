#!/bin/bash

# ./lab8-check.bash

# Author:  Murray Saul
# Date:    November 18, 2016
#
# Purpose: 

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
cat <<+
ATTENTION:

In order to run this shell script, please
have the following information ready:

 - Your c7host and your centos1 and centos3 VMs are running.
   
 - Your centos1 username.
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

# Make certain user is logged in as root
if [ $USER != "root" ]
then
  echo "Note: You are required to run this program as root."
  exit 1
fi

# Start checking lab8
echo
echo "CHECKING YOUR LAB8 WORK:"
echo


# Check option BOOTPROTO set to "dhcp" in "ifcfg-eth0" file
echo "Checking BOOTPROTO set to \"dhcp\" for \"ifcfg-eth0\" centos1 VM: "
read -p "Enter your centos1 username: " centos1UserName
check "ssh $centos1UserName@192.168.235.42 grep -sqi BOOTPROTO.*dhcp /etc/sysconfig/network-scripts/ifcfg-eth0" "This program did not detect the value \"dhcp\" for the BOOTPROTO option in the file called \"ifcfg-eth0\" on your centos1 VM. Another reason why this error occurred is that you didn't complete the last section to add a host for centos1 using the IPADDR \"192.168.235.42\". Please make corrections, reboot your centos3 VM, and re-run this checking shell script."

# Check that dhcp server is running on centos3 VM
echo "Checking that dhcp service is currently running on your centos3 VM: "
check "ssh root@centos3 systemctl status dhcpd | grep -iqs active" "This program did not detect that the \"dhcp\" service is running (active). Please make corrections, and re-run this checking shell script."

# Check DHCPDISCOVER, DHCPOFFER, DHCPREQUEST & DHCPACK for centos3 on /var/log/messages
echo "Checking \" DHCPDISCOVER, DHCPOFFER, DHCPREQUEST & DHCPACK\" on"
echo " \"/var/log/messages\" on centos3 VM: "
check "ssh root@centos3 \"(grep -iqs DHCPDISCOVER /var/log/messages &&  grep -iqs DHCPOFFER /var/log/messages && grep -iqs DHCPREQUEST /var/log/messages && grep -iqs DHCPACK /var/log/messages)\"" "This program did not detect the messages containing \" DHCPDISCOVER or DHCPOFFER or DHCPREQUEST or DHCPACK\" relating to \"centos3\" for your centos3 VM. Please make corrections, and re-run this checking shell script."

# Check for non-empty "/var/lib/dhcpd/dhcpd.leases" file on centos3 VM
echo "Checking for non-empty \"/var/lib/dhcpd/dhcpd.leases\" file on centos3 VM: "
check "ssh ops235@centos3 test -s /var/lib/dhcpd/dhcpd.leases " "This program did not detect the NON-EMPTY file called \"/var/lib/dhcpd/dhcpd.leases\" file in your centos3 VM. Please make corrections, and re-run this checking shell script."

# Check that centos3 can ping centos host (IPADDR: 192.168.235.42)
echo "Checking that centos3 VM can ping centos1 host (IPADDR: \"192.168.235.42\"): "
check "ssh ops235@centos3 ping -c1 192.168.235.42 > /dev/null 2> /dev/null" "This program did not detect that there was an ip address set for any network interface card (i.e. eth0) for the value: \"192.168.235.42\". Please make corrections, and re-run this checking shell script."

# Check that "/var/lib/dhclient" directory is non-empty on centos1 VM
echo  "Checking that \"/var/lib/dhclient\" directory is non-empty on centos1 VM: "
check "ssh $centos1UserName@192.168.235.42 ls /var/lib/dhclient | grep -sq ." "This program did not detect regular files contained in the \"/var/lib/dhclient\" directory - this indicates that the dhcp process did not correctly for your centos1 VM when you issued the command \"dhclient\". Please make corrections, and re-run this checking shell script."

echo
echo
echo "Congratulations!"
echo
echo "You have completed your lab8. Please check SIGN-OFF section"
echo "To setup your terminals and command output, etc. to show your"
echo "OPS235 instructor for SIGN-OFF."
echo
cat <<+
ATTENTION: Make certain that your OPS instructor records
           your labs (i.e. on your title page) since you
           have now completed all the labs for this course!


+
