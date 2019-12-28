#!/bin/bash

# ./lab1-check.bash

# Author:  Murray Saul
# Date:    May 22, 2016
#
# Purpose: Check that students correctly installed the centos1 VM
#          and properly performed common Linux commands. Script will
#          exit if errors, but provide feedback to correct the problem.

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

# Start checking lab1
echo
echo "CHECKING YOUR LAB1 WORK:"
echo

# Check version of Linux distribution
echo -n "Checking Correct Linux Distribution: "
check "grep -iqs \"VERSION=.*7\" /etc/os-release && grep -iqs \"centos\" /etc/os-release" " Your version of Centos is not 7. You are required to use Centos 7 in order to perform these labs. Install the correct version of Centos7 Full DVD (links on the main OPS235 WIKI) and re-run this shell script."

# Checking for correct partitions created
echo -n "Checking that root partition was created: "
check "lsblk -f | grep  /$ | grep -isq ext4" "You needed to create a root partition (file system type: ext4). Please reinstall the c7host and re-run this shell script."

echo -n "Checking that \"/home\" partition was created: "
check "lsblk -f | grep  /home$ | grep -isq ext4" "You needed to create a \"/home\" partition (file system type: ext4). Please reinstall the c7host and re-run this shell script."

echo -n "Checking that \"/var/lib/libvirt/images\" partition was created: "
check "lsblk -f | grep  /var/lib/libvirt/images$ | grep -isq ext4" "You needed to create a \"/var/lib/libvirt/images\" partition (file system type: ext4 with correct absolute images pathname correctly spelled). Please reinstall the c7host and re-run this shell script."

# Checking for correct sizes for the partitions created
echo -n "Checking that the root partition is at least 30GB: "
check "test `df | grep /$ | awk '{print $2;}'` -ge 30000000" "The size of the root partition must be at least 30GB. Please reinstall the c7host and re-run this shell script."

echo -n "Checking that the /home partition is at least 40GB: "
check "test `df | grep /home$ | awk '{print $2;}'` -ge 40000000" "The /home partition must be at least 40GB. Please reinstall the c7host and run-run this shell script."

echo -n "Checking that the \"/var/lib/libvirt/images\" partition is at least 100GB: "
check  "test `df | grep /var/lib/libvirt/images$ | awk '{print $2;}'` -ge 100000000" "The \"/var/lib/libvirt/images\" partition must be at least 100GB. Please reinstall the c7host and run-run this shell script."

# Checking for network connectivity
echo -n "Checking for network connectivity: "
check "wget -qO- http://google.ca &> /dev/null" "The size of the root partition must be 20GB. Please reinstall the c7host VM and re-run this shell script."

# Check if SELinux is disabled
echo -n "Checking that SELinux is disabled: "
check "grep -isq SELINUX=disabled /etc/selinux/config" "According to your \"/etc/selinux/config\" file, the variable SELINUX is not set to \"disabled\" (i.e. NOT \"enforcing\"). Please make corrections and re-run this shell script."

# Check if /root/bin directory was created
echo -n "Checking that \"/root/bin\" directory was created:"
check "test -d \"/root/bin\"" "This program did NOT detect that the \"/root/bin\" directory was created. Please create this directory, and re-run this shell script."

# Check for existence of /root/bin/myreport.bash script
echo -n "Checking that \"/root/bin/myreport.bash\" script exists:"
check "test -f \"/root/bin/myreport.bash\"" "This program did NOT detect the existence of the file pathname \"/root/bin/myreport.bash\". Please create this script at that pathname and re-run this shell script."

# Check that myreport.bash script was run
echo -n "Checking that \"/root/bin/myreport.bash\" script was run:"
check "test -f \"/root/report.txt\"" "This program did NOT detect the existence of the file \"/root/report.txt\" and may indicate that the shell script was NOT run. Please run the shell script correctly and re-run this shell script."






echo
echo
echo "Congratulations:"
echo
echo "You have completed your lab1. Please check SIGN-OFF section"
echo "To setup your terminals and command output, etc. to show your"
echo "OPS235 instructor for SIGN-OFF."
echo
