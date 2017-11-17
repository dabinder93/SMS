#!/bin/bash
CoockieSave=~/.mozilla/firefox/w567m1so.default/cookies.sqlite

if [[ "$1" = "host" ]]; then
	if [ -z "$2" ]
		then
		  echo "Second parameter must contain a host"
		  exit 1
	fi
	COOKIES=$(sqlite3 -line "$CoockieSave" "select * from moz_cookies where host like '$2'")
elif [[ "$1" = "pattern" ]]; then
	if [ -z "$2" ]
		then
		  echo "Second parameter must contain a pattern!"
		  exit 1
	fi
	COOKIES=$(sqlite3 -line "$CoockieSave" "select * from moz_cookies where host like '%$2%'")
else
	echo "Wrong Arguments!"
 	echo "First parameter must be \'host\' or \'pattern\'"
	exit 1;
fi
COOKIES=${COOKIES//" = "/": "}
echo "Num of Cookies found: "$(echo "$COOKIES" | grep -o "id: " | wc -l)
echo "$COOKIES"