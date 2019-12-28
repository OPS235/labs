#!/bin/bash

# Author: INSERT YOUR NAME HERE
# Date:   INSERT DATE HERE
#
# Purpose: Loads network information for your local machine
#
# USAGE: ./array1.bash [file-path-name]

if [ $USER != "root" ] # only runs if logged in as root
then
 echo "You must be logged in as root." >&2
 exit 1
fi

if [ $# -ne 1 ]
then
 echo "You need to provide a file-pathname" >&2
 echo "USAGE: $0 [file-path-name]" >&2
 exit 0
fi

while read line
do
 network[$index]="$line"
 index=$(($index+1))
done < $1

cat > /root/network-info.html <<+
<!DOCTYPE html>
<html>
 <head>
   <title>Network Information</title>
 </head>
 <body>
  <h3>Network Information for: $1</h3>
  <table cellpadding="5" cellspacing="0" border="1">
  <tr><td><b>Option Name</b></td><td><b>Option Value</b></td></tr>
+

for((x=0; x<$index; x++))
do
 echo ${network[$x]} | awk -F"=" '{print "<tr><td>",$1,"</td><td>",$2,"</td></tr>"}' >> /root/network-info.html
done

cat >> /root/network-info.html <<+
  </table>
 </body>
</html>
+

/bin/firefox /root/network-info.html
