#!/bin/bash
if [ -f "banner.txt" ] ; then 
	rm "banner.txt" 
fi

if [ ! -f "server_list.txt" ] ; then
	echo "No 'server_list.txt' file found!"
	exit 1
fi 

while read -r url || [ -n "$url" ] ; do
	serverbanner=$( printf "HTTP HEAD HTTP/1.0\n\n" \
		| ncat "$url" -vC 80 2>&1 | grep -E "^Server: " \
		| cut -d ' ' -f2 )
	printf "$url \t $serverbanner\n" >> "banner.txt"
done < "server_list.txt"
cat "banner.txt"