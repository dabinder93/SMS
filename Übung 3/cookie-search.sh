#!/bin/bash
CoockieSave=~/.mozilla/firefox/s2wu824a.default/cookies.sqlite

if [[ "$1" = "host" ]]; then
	if [ -z "$2" ]
		then
		  echo "Error, parameter 2 must contain a host!"
		  exit 1
	fi
	COOKIES=$(sqlite3 -line "$CoockieSave" "select * from moz_cookies where host like '$2'")
elif [[ "$1" = "pattern" ]]; then
	if [ -z "$2" ]
		then
		  echo "Error, parameter 2 must contain a pattern!"
		  exit 1
	fi
	COOKIES=$(sqlite3 -line "$CoockieSave" "select * from moz_cookies where host like '%$2%'")
else
	echo "Error, false Arguments!"
 	echo "Param 1 must be either \'host\' or \'pattern\'!"
	exit 1;
fi

COOKIES=${COOKIES//" = "/": "}
echo "Number of Cookies found: "$(echo "$COOKIES" | grep -o "id: " | wc -l)
echo "$COOKIES"