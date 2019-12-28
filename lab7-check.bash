#!/bin/bash

# ./lab7-check.bash

# Author:  Murray Saul
# Date:    June 28, 2016
# Modified: November 2, 2016
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

 - Your c7host and ALL of your VMs are running.
   
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

# Start checking lab7
echo
echo "CHECKING YOUR LAB7 WORK:"
echo


# Check myfile.txt copied to user's Matrix home directory
echo "Checking file \"myfile.txt\" copied to user's Matrix home directory: "
read -p "Enter your username for matrix: " matrixUserName
check "ssh $matrixUserName@matrix.senecac.on.ca ls /home/$matrixUserName/myfile.txt > /dev/null 2>/dev/null" "This program did not detect the file called \"myfile.txt\" in your Matrix account's home directory. Please make corrections, and re-run this checking shell script."

# Check that the account "other" was created
echo "Checking that the user called \"other\" was created: "
read -p "Enter your username for your centos1 VM: " centos1UserName
check "ssh $centos1UserName@centos1 grep -sq other /etc/passwd" "This program did not detect the user called \"other\" in your centos1 VM. Please make corrections, and re-run this checking shell script."

# Check that PermitRootLogin in /etc/ssh/sshd_config file was set to no
echo "Checking \"PermitRootLogin\" set to \"no\" (sshd_config backup): "
check "ssh $centos1UserName@centos1 grep -qsi PermitRootLogin.*no /home/$centos1UserName/sshd_config.bk" "This program did not detect the option \"PermitRootLogin\" was set to \"no\" in the \"/home/$centos1UserName/sshd_config.bk\" file in your centos1 VM. Please make corrections, and re-run this checking shell script."

# Check that account called other is AllowUsers in sshd_config file
echo "Checking user \"other\" added to \"AllowUsers\" option (sshd_config backup): "
check "ssh $centos1UserName@centos1 grep -sq AllowUsers.*other.* /home/$centos1UserName/sshd_config.bk" "This program did not detect the option \"AllowUsers\" including the \"other\" account in the \"/home/$centos1UserName/check_ssh.bk\" file in your centos1 VM. Please make corrections, and re-run this checking shell script."

# Check that public key created in centos2 VM
echo "Checking that public key created in \"centos2\" VM: "
check "ssh $centos1UserName@centos2 ls /home/$centos1UserName/.ssh/id_rsa.pub > /dev/null" "This program did not detect the public key \"/home/$centos1UserName/.ssh/id_rsa.pub\" in the centos2 VM. Please make corrections, and re-run this checking shell script."

# Check that public key copied to the centos3 VM
echo "Checking that public key copied to the \"centos3\" VM: "
check "ssh ops235@centos3 ls /home/ops235/.ssh/authorized_keys > /dev/null" "This program did not detect the public key \"/home/ops235/.ssh/authorized_keys\" in the centos3 VM. Please make corrections, and re-run this checking shell script."

# Have student run the command to remotely run gedit application
cat <<+
You will now be required to run the ssh command using tunnelling to
run the gedit application from centos1, but display in your c7host machine.
Type the command at the prompt below:

+
read -p "Enter ssh command here: " studentCommand
until [ "$studentCommand" = "ssh -X -C $centos1UserName@centos1 gedit" -o "$studentCommand" = "ssh -C -X $centos1UserName@centos1 gedit" -o "$studentCommand" = "ssh -XC $centos1UserName@centos1 gedit" -o "$studentCommand" = "ssh -CX $centos1UserName@centos1 gedit" ]
do
   echo "Error: Refer to lab7 to run gedit command remotely via ssh"
   read -p "Enter correct ssh command with gedit argument here: " studentCommand
done

ssh -f -X -C $centos1UserName@centos1 gedit > /dev/null 2> /dev/null && echo -e "\e[0;32mOK\e[m"

# check for iptables policy
echo -n "Checking for history of setting of default iptables policy: "
check "history | grep 'iptables -P INPUT DROP' | head -1" "This program did not detect when viewing results from the \"history\" command the iptables command: \"iptables -P INPUT DROP\". Please make corrections, REBOOT your c7host machine, and re-run this checking shell script."

# check for iptables exception web traffic
echo -n "Checking for history of setting web traffic exception: "
check "history | grep 'iptables -A INPUT.*-p.*tcp.*--dport.*80.*ACCEPT' | head -1" "This program did not detect when viewing results from the \"history\" command the iptables command: \"iptables -A INPUT -p tcp --dport 80 -j ACCEPT\". Please make corrections, REBOOT your c7host machine, and re-run this checking shell script."

# check for iptables exception for pinging
echo -n "Checking for history of setting ping exception: "
check "history | grep -sq 'iptables -A INPUT.*-p.*icmp.*ACCEPT' | head -1" "This program did not detect when viewing results from the \"history\" command the iptables command: \"iptables -A INPUT -p icmp -s {lab-mates external-facing ip address} -j ACCEPT\". Please make corrections, REBOOT your c7host machine,  and re-run this checking shell script."

# check for iptables exception for ssh
echo -n "Checking for history of setting ping exception: "
check "history | grep -sq 'iptables -A INPUT.*-p.*tcp.*--dport.*22.*ACCEPT' | head -1" "This program did not detect when viewing results from the \"history\" command the iptables command: \"iptables -A INPUT -p tcp -s {lab-mates external-facing ip address} --dport 22 -j ACCEPT\". Please make corrections, REBOOT your c7host machine, and re-run this checking shell script."

# check for backing up iptables file to a backup file
echo -n "Checking for history of backing up iptables rules to a file: "
check "history | grep -sq 'iptables-save > /etc/sysconfig/iptables.bk' | head -1" "This program did not detect when viewing results from the \"history\" command the iptables command: \"iptables-save > /etc/sysconfig/iptables.bk\". Please make corrections, REBOOT your c7host machine, and re-run this checking shell script."

# check for making iptables rules persistent
echo -n "Checking for history for making iptables rules persistent: "
check "history | grep -sq 'iptables-save > /etc/sysconfig/iptables' | head -1" "This program did not detect when viewing results from the \"history\" command the iptables command: \"iptables-save > /etc/sysconfig/iptables\". Please make corrections, REBOOT your c7host machine, and re-run this checking shell script."

echo
echo
echo "Congratulations!"
echo
echo "You have completed your lab7. Please check SIGN-OFF section"
echo "To setup your terminals and command output, etc. to show your"
echo "OPS235 instructor for SIGN-OFF."
echo
