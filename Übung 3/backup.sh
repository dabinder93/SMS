#!/bin/bash
if [ -z "$1" ]
  then
    echo "A Path as parameter is necessary!"
    exit 1
fi

BASENAME=`basename "$1"`

if [ -d "$1" ]
then
	if find $1 -mtime -1 -type f 2>/dev/null | xargs tar cfj "$BASENAME"_backup_$(date +%H_%M_%d_%m_%Y).tar.bz2 2>/dev/null
	then
		echo "The directory was saved."
	else
		echo "No files for a backup found!"
	fi;
else
	echo "No such Directory"
fi;
echo "Done!"