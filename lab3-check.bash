#!/bin/bash

# ./lab3-check.bash

# Author:  Murray Saul
# Date:    June 7, 2016
#
# Purpose: Check that students correctly archived and installed and
#          removed software on their VMs

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

 - IPADDRESSES for only your centos3 VM.
   Remember that your password for your ops235 account
   in centos3 is "ops235"!!!!

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






# Start checking lab3
echo
echo "CHECKING YOUR LAB3 WORK:"
echo

centos3UserName="ops235"



# Check creation of /tmp/archive1.tar archive file (centos3)
echo "Checking creation of \"/tmp/extract1/archive1.tar\" archive file (centos3): "
read -p "Enter IP Address for your centos3 VMs eth0 device: " centos3_IPADDR
check "ssh $centos3UserName@$centos3_IPADDR test -f /tmp/extract1/archive1.tar" "This program found there is no file called: \"/tmp/extract1/archive1.tar\" on your \"centos3\" VM. Please create this archive again (for the correct VM), and re-run this checking shell script."

# Check creation of /tmp/archive2.tar.gz zipped tarball (centos3)
echo "Checking creation of \"/tmp/extract2/archive2.tar.gz\" archive file (centos3): "
check "ssh $centos3UserName@$centos3_IPADDR test -f /tmp/extract2/archive2.tar.gz" "This program found there is no file called: \"/tmp/extract2/archive2.tar.gz\" on your \"centos3\" VM. Please create this archive again (for the correct VM), and re-run this checking shell script."

# Check for restored archive in /tmp/extract1 directory (centos3)
echo "Checking archive1.tar restored to \"/tmp/extract1\" directory (centos3): "
check "ssh $centos3UserName@$centos3_IPADDR test -d /tmp/extract1" "This program found that the \"archive1.tar\" was not properly restored to directory \"/tmp/extract1\" directory in your \"centos3\" VM. Please restore this archive again (for the correct VM), and re-run this checking shell script."

# Check for restored archive in /etc/extract2 directory (centos3)
echo "Checking archive2.tar.gz restored to \"/tmp/extract2\" directory (centos3): "
check "ssh $centos3UserName@$centos3_IPADDR test -d /tmp/extract2" "This program found that the \"archive2.tar.gz\" was not properly restored to directory \"/tmp/extract2\" directory in your \"centos3\" VM. Please restore this archive again (for the correct VM), and re-run this checking shell script."

# Check for removal of elinks application (centos1)
echo "Checking for removal of \"elinks\" application: "
check "! which elinks > /dev/null 2> /dev/null" "This program found that the \"elinks\" application was NOT removed on your \"c7host\" VM. Please re-do this task, and then re-run this checking shell script."

# Check for install of xchat application (centos1)
echo -n "Checking for install of \"xchat\" application: "
check "which xchat" "This program found that the \"xchat\" application was NOT installed on your \"c7host\" VM. Please re-do this task, and then re-run this checking shell script."


# Check for epel repository added to c7host (Note: this may take a few moments - be patient):
echo -n "Checking for \"epel\" repository added to repolist (c7host). Note: This may take a few moments (please be patient): "
check "yum repolist | grep -isq \"epel\"" "This program did NOT detect that the \"epel\" repository was added to the repository list. Please re-do the task to add the \"epel\" repository to the repository list, issue the \"yum repolist\" command to verify it has been added, and then re-run this checking shell script."

# Check for presence of lbreakout or lbreakout2  application (centos1)
echo -n "Checking for presence of \"lbreakout\" application (centos1): "
check "which lbreakout > /dev/null 2> /dev/null || which lbreakout2 > /dev/null 2> /dev/null" "This program did NOT detect that the game called \"lbreakout2\" was installed on your \"c7host\" VM. Please follow the instructions to properly compile your downloaded source code (perhaps ask your instructor or lab assistant for help), and then re-run this checking shell script."

# Check for presence of packageInfo.bash bash shell script
echo -n "Checking for presence of \"/root/bin/packageInfo.bash\" script: "
check "test -f /root/bin/packageInfo.bash" "This program did NOT detect the presence of the file: \"/root/bin/packageInfo.bash\". Please create this shell script in the correct location, assign execute permissions, and run this shell script, and then re-run this checking shell script."

# Check packageInfo.bash shell script was run
echo -n "Checking for presence of \"/root/package-info.txt\" report: "
check "test -f /root/package-info.txt" "This program did NOT detect the presence of the file: \"/root/package-info.txt\". Please create this shell script in the correct location, assign execute permissions, and run this shell script, and then re-run this checking shell script."

echo
echo
echo "Congratulations!"
echo
echo "You have completed your lab3. Please check SIGN-OFF section"
echo "To setup your terminals and command output, etc. to show your"
echo "OPS235 instructor for SIGN-OFF."
echo
