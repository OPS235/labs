#!/bin/bash

# ./lab2-check.bash

# Author:    Murray Saul
# Date:      May 22, 2016
# Modified:  September 15, 2016
#
# Purpose: Check that students correctly installed centos1, centos2,
#          and centos3 VMs. Check that VMs installed correctly
#          (ext4 filesystem, sizes, SElinux disabled).
#          Check that VMs were backed-up, and backup script created

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

# Banner

cat <<+
ATTENTION:

In order to run this shell script, please
have the following information ready:

 - IPADDRESSES for your centos1 and centos2 VMs
   For your centos2 VM, the ifconfig command does
   not work. Instead, use the command:
   ip address

 - Your regular username password for c7host and ALL VMs.
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


# Start checking lab2
echo
echo "CHECKING YOUR LAB2 WORK:"
echo

# Insert various checks here

# Check if /root/bin directory exists in c7host VM
echo -n "Checking for existence of \"/root/bin\" directory in c7host: "
check "test -d /root/bin" "There is no bin directory contained in root's home directory in your c7host VM. You need to issue command: \"mkdir /root/bin\" and re-run this shell script."

# Check if /root/bin/lab2-check.bash path exists
echo -n "Checking for pathname \"/root/bin/lab2-check.bash\""
check "test -f /root/bin/lab2-check.bash" "The \"lab2-check.bash\" file should be contained in the \"/root/bin\" directory where all shell scripts should be for the Linux system administrator. Please location that file to the directory, and re-run this checking shell script."

# Check that all 3 VMs have been created
echo -n "Checking that \"centos1\", \"centos2\", and \"centos3\" VMs have been created:"
check "virsh list --all | grep -isq centos1 && virsh list --all | grep -isq centos2 && virsh list --all | grep -isq centos3" "This program detected that not ALL VMs have been created (i.e. centos1, centos2, centos3). Please create these VMs with the correct VM names, and re-run this checking shell script."


# Check that all 3 VMs are running
echo -n "Checking that \"centos1\", \"centos2\", and \"centos3\" VMs are ALL running:"
check "virsh list | grep -isq centos1 && virsh list | grep -isq centos2 && virsh list | grep -isq centos3" "This program detected that not ALL VMs (i.e. centos1, centos2, centos3) are running. Please make certain that ALL VMs are running, and re-run this checking shell script."

# Check centos1 VM has \"ext4\" file-system types
echo "Checking that \"centos1\" has correct ext4 file-system type:"
read -p "Enter the username that you created for your c7host and ALL VMs: " UserName
read -p "Enter IP Address for your centos1 VMs eth0 device: " centos1_IPADDR
check "ssh $UserName@$centos1_IPADDR \"lsblk -f | grep -i /$ | grep -iqs \"ext4\"\"" "This program detected that your centos1 VM does NOT have the correct filesystem type (ext4) for your / partition. Please remove and recreate the \"centos1\" VM, and re-run this checking shell script."

# Check centos2 VM has \"ext4\" file-system types
echo "Checking that \"centos2\" has correct ext4 file-system types:"
read -p "Enter IP Address for your centos2 VMs eth0 device: " centos2_IPADDR
check "ssh $UserName@$centos2_IPADDR \"lsblk -f | grep -iqs \"ext4\" && lsblk -f | grep -i /home$ | grep -iqs \"ext4\"\"" "This program detected that your centos2 VM does NOT have \"ext4\" file system types for / and/or /home partitions. Please remove and recreate the \"centos2\" VM, and re-run this checking shell script."


# Check centos2 VM has correct partition sizes
echo "Checking that \"centos2\" has correct partition sizes:"
check "ssh $UserName@$centos2_IPADDR \"lsblk | grep -isq \"2G.*/home\" && lsblk | grep -isq \"8G.*/\"\"" "This program detected that your centos2 VM does NOT have correct partition sizes for  / and/or /home partitions. Please remove and recreate the \"centos2\" VM, and re-run this checking shell script."


# centos3 does not have to be checked since it was automatically setup...


# Check centos1 VM image file is in "images" directory
echo "Checking that \"/var/lib/libvirt/images/centos1.qcow2\" file exists:"
check "test -f /var/lib/libvirt/images/centos1.qcow2" "This program detected that the file pathname \"/var/lib/libvirt/images/centos1.qcow2\" does NOT exist. Please remove, and recreate the centos1 VM, and then re-run this checking shell script."

# Check centos2 VM image file is in "images" directory
echo -n "Checking that \"/var/lib/libvirt/images/centos2.qcow2\" file exists:"
check "test -f /var/lib/libvirt/images/centos2.qcow2" "This program detected that the file pathname \"/var/lib/libvirt/images/centos2.qcow2\" does NOT exist. Please remove, and recreate the centos1 VM, and then re-run this checking shell script."

# Check centos3 VM image file is in "images" directory
echo -n "Checking that \"/var/lib/libvirt/images/centos3.qcow2\" file exists:"
check "test -f /var/lib/libvirt/images/centos3.qcow2" "This program detected that the file pathname \"/var/lib/libvirt/images/centos3.qcow2\" does NOT exist. Please remove, and recreate the centos3 VM, and then re-run this checking shell script."

# Check that  backupVM.bash script was created in /root/bin directory
echo -n "Checking that file pathname \"/root/bin/backupVM.bash\" exists:"
check "test -f /root/bin/backupVM.bash" "This program detected that the file pathname \"/root/bin/backupVM.bash\" does NOT exist. please make fixes to this script, and re-run this checking shell script."

# Check centos1 VM backed up (qcow2)
echo -n "Checking that centos1 backed up in user's home directory:"
check "test -f /home/$UserName/centos1.qcow2.backup.gz" "This program detected that the file pathname \"/home/$c7hostUserName/centos1.qcow2.backup.gz\" does NOT exist. Please properly backup the centos1 VM (using gzip) to your home directory, and then re-run this checking shell script."

# Check centos2 VM backed up (qcow2)
echo -n "Checking that centos2 backed up in user's home directory:"
check "test -f /home/$UserName/centos2.qcow2.backup.gz" "This program detected that the file pathname \"/home/$c7hostUserName/centos2.qcow2.backup.gz\" does NOT exist. Please properly backup the centos2 VM (using gzip) to your home directory, and then re-run this checking shell script."

# Check centos3 VM backed up (qcow2)
echo "Checking that centos3 backed up in user's home directory:"
check "test -f /home/$UserName/centos3.qcow2.backup.gz" "This program detected that the file pathname \"/home/$c7hostUserName/centos3.qcow2.backup.gz\" does NOT exist. Please properly backup the centos3 VM (using gzip) to your home directory, and then re-run this checking shell script."

echo
echo
echo "Congratulations:"
echo
echo "You have completed your lab2. Please check SIGN-OFF section"
echo "To setup your terminals and command output, etc. to show your"
echo "OPS235 instructor for SIGN-OFF."
echo
