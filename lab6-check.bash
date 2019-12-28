#!/bin/bash

# ./lab6-check.bash

# Author:  Murray Saul
# Date:    June 27, 2016
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

 - Your c7host and centos1, centos2, and centos3 VMs running.
   
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

# Start checking lab6
echo
echo "CHECKING YOUR LAB6 WORK:"
echo

# Check if c7host can ping 192.168.235.1
echo -n "Checking pinging 192.168.235.1 (c7host): "
check "ping 192.168.235.1 -c 1 > /dev/null 2>&1" "This program could not ping itself. Please make fixes, and re-run this checking shell script."

# Check if c7host can ping 192.168.235.11
echo -n "Checking pinging 192.168.235.11 (centos1): "
check "ping 192.168.235.11 -c 1 > /dev/null 2>&1" "This program could not ping centos1. Please make appropriate corrections, and re-run this checking script."

# Check if c7host can ping 192.168.235.12
echo -n "Check pinging 192.168.235.12 (centos2): "
check "ping 192.168.235.12 -c 1 > /dev/null 2>&1" "This program could not ping centos2. Please make appropriate corrections, and re-run this checking script."

# Check if c7host can ping 192.168.235.13
echo -n "Check pinging 192.168.235.13 (centos3): "
check "ping 192.168.235.13 -c 1 > /dev/null 2>&1" "This program could not ping centos3. Please make appropriate corrections, and re-run this checking script."

# Check for persistent setting on centos1
echo "Check for persistent setting on centos1: "
read -p "Enter your username for centos1: " centos1UserName
check "ssh ${centos1UserName}@centos1 grep -isq 192.168.235.11 /etc/sysconfig/network-scripts/ifcfg-eth0" "This program could find a correct address for the ifcfg-eth0 file. Please make fixes, and re-run this checking shell script."

# Check for persistent setting on centos2
echo "Check for persistent setting on centos2: "
check "ssh ${centos1UserName}@centos2 grep -isq 192.168.235.12 /etc/sysconfig/network-scripts/ifcfg-eth0" "This program could find a correct address for the ifcfg-eth0 file. Please make fixes, and re-run this checking shell script."

# Check for persistent setting on centos3
echo "Check for persistent setting on centos3 (use password: \"ops235\"): "
check "ssh ops235@centos3 grep -isq 192.168.235.13 /etc/sysconfig/network-scripts/ifcfg-eth0" "This program could not find a correct address for the ifcfg-eth0 file. Please make fixes, and re-run this checking shell script."

# Check if can ping c7host name
echo -n "Checking pinging c7host: "
check "ping c7host -c 1 > /dev/null 2>&1" "This program could not ping itself. Please make fixes, and re-run this checking shell script."

# Check if can ping centos1 host name
echo -n "Checking pinging centos1: "
check " ping centos1 -c 1 > /dev/null 2>&1" "This program could not ping centos1. Please make appropriate corrections, and re-run this checking script."

# Check if can ping centos2 host name
echo -n "Check pinging centos2: "
check "ping centos2 -c 1 > /dev/null 2>&1" "This program could not ping centos2. Please make appropriate corrections, and re-run this checking script."

# Check if can ping centos3 host name
echo -n "Check pinging centos3: "
check "ping centos3 -c 1 > /dev/null 2>&1" "This program could not ping centos3. Please make appropriate corrections, and re-run this checking script."

# Check existance of network-info.bash script
echo -n "Checking existance of \"/root/bin/network-info.bash\" script: "
check "test -f /root/bin/network-info.bash" "This program could not detect the pathname: \"/root/bin/network-info.bash\". Please download and run the script, and re-run this checking script."

# Check proof that network-info.bash script was run
echo -n "Checking existance of \"/root/network-info.html\" script: "
check "test -f /root/network-info.html" "This program could not detect the pathname: \"/root/network-info.html\". Please download and run the script, and re-run this checking script."

echo
echo
echo "Congratulations!"
echo
echo "You have completed your lab6. Please check SIGN-OFF section"
echo "To setup your terminals and command output, etc. to show your"
echo "OPS235 instructor for SIGN-OFF."
echo
