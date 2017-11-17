#!/bin/bash

if [ -z $1 ]
  then
    echo "Parameter must contain uid or username"
    exit 1
fi

if [ -z "$(getent passwd $1)" ]
  then
    echo "no such user"
    exit 1
fi
 
echo -e "Username: \t $(getent passwd $1 | cut -d: -f1 | sort -r)"

echo -e "Password: \t $(getent passwd $1 | cut -d: -f2 | sort -r)"
 
echo -e "UID: \t\t $(getent passwd $1 | cut -d: -f3 | sort -r)"
 
echo -e "GID: \t\t $(getent  passwd $1 | cut -d: -f4 | sort -r)"
 
echo -e "User ID Info: \t $(getent passwd $1 | cut -d: -f5 | sort -r)"
 
echo -e "Home directory: \t $(getent passwd $1 | cut -d: -f6 | sort -r)"
 
echo -e "Shell: \t\t $(getent passwd $1 | cut -d: -f7 | sort -r)"


userPass=$(sudo cat /etc/shadow | grep $1 | cut -d ':' -f2)
 
if [[ $userPass == "*" ]] || [[ $userPass == "!" ]]; then
    echo -e "Password \t is invalid, not active"
elif [[ $userPass == " " ]]; then
    echo -e "Password \t is not set"
else
    echo -e "Password: \t is set"
fi
 

homeDir=$(getent passwd $1 | cut -d: -f6 | sort -r)
if ! [ -z "$homeDir" ]; then
    echo "Home directory: \t $homeDir"
 
    filecount=$(find $homeDir -type f 2>/dev/null | wc -l)
    echo -e "Files: \t\t $filecount"
     
    sizeOfFiles=$(du -hs $homeDir 2>/dev/null | cut -d "/" -f1)
    echo -e "Size: \t\t $sizeOfFiles"
else
    echo "No home directory found"
fi