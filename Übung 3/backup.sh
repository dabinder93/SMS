#!/bin/bash
#Script for backing up a path from a parameter 

if [ -z "$1" ]
  then
    echo "A Path as parameter is mandatory!"
    exit 1
fi


BASENAME=`basename "$1"`

#check if the di exists
if [ -d "$1" ]
then
#-mtime for searching data which is changed in the last 24 Hours ()
#without -type f the script duplicates some files
	if find $1 -mtime -1 -type f 2>/dev/null | xargs tar cfj "$BASENAME"_backup_$(date +%H_%M_%d_%m_%Y).tar.bz2 2>/dev/null
	then
		echo "The directory was saved."
	else
		echo "No files for a backup found!"
	fi;
else
	echo "Dir not found!"
fi;

echo "Finished!"