#!/bin/sh

# Add a bunch of useless comments
# just to change the file
# testing this git setup
# Why do I have to check this myself?

if [ "$1" = "-h" ]
then
echo ""
echo "Usage: update-hostname.sh <path>"
echo ""
echo "   The script will recursively search for git repositories under the"
echo "   <path> directory and update the configuration file to include the"
echo "   new hostname of the Euclid GitLab server."
echo ""
echo "   If <path> is left blank, the script will search from the current"
echo "   working directory."
echo ""
exit 0
fi

if [ "$1" = "" ]
then
   pathtocheck="."
else 
   pathtocheck=$1
fi

for a in `find $pathtocheck -path \*/.git/config -print`
do
   echo "Checking $a"
   grep "euclid-git.roe.ac.uk" $a > /dev/null
   if [ "$?" -eq "0" ]
   then
      echo "Updating $a"
      backupfile="$a.backup"
      mv $a $backupfile
      if [ "$?" -gt "0" ]
      then
         echo "Failed to create backup of $a. Exiting."
         exit 1
      fi
      cat $backupfile | sed 's/euclid-git.roe.ac.uk/gitlab.euclid-sgs.uk/' > $a
      if [ "$?" -gt "0" ]
      then
         echo "Failed to write to $a. Exiting."
         exit 1
      fi
   fi
done

exit 0

