#Übung 5
###1.1 Capture all packets at a network interface, which use the UDP protocol and any destination port from 1 to 1024.

sudo tcpdump -n udp dst portrange 1-1024

###1.2 Capture all broadcast and multicast packets.

sudo tcpdump -n "broadcast or multicast"

###1.3 Capture all packets, whose destination is host 192.168.1.1, except for packets to port 80 (http) or port 23 (telnet).

sudo tcpdump -n "dst host 192.168.1.1 and not(dst port 80 or dst port 23)"


###1.4 Find a way to capture all TCP packets, where the RST flag is set (abnormal connection closure).

sudo tcpdump 'tcp[13]&4!=0'


###1.5 Set up tcpdump to capture HTTP packets only, and save the captured packets to a file. Browse the web for a few minutes and stop capturing. Then use the tshark utility to open and print the captured packets, and use common shell utilities to extract a list of all distinct destination hosts/IPs.

tshark -r capture.cap | sed -e 's/^[[:space:]]*//' -e 's/ */ /g' | cut -d ' ' -f 5 | sort -n | uniq

##2.
- File ausführbar machen:  'chmod 755 mystery64'
- File ausführen ./mystery64
![Alt text](A:\FH\WS17\SMS\Repo\Übung 5\Aufgabe 2\mystery_output.png?raw=true)

- ltrace auf die file ausführen

![Alt text](A:\FH\WS17\SMS\Repo\Übung 5\Aufgabe 2\ltrace_output.png?raw=true)
- "MC14rocks verdächtig", dieses als Passwort probiert -> hat funktioniert!

![Alt text](A:\FH\WS17\SMS\Repo\Übung 5\Aufgabe 2\mystery_executed.png?raw=true)

- Mit ltrace lässt sich herausfinden, dass das Programm listened.
- Als nächstes wird Text ausgegeben ("Hello World! ...").
- Danach wird die /etc/passwd file geöffnet und mit malloc(20) speicher allokiert.
- der String "MC14" wird an die Stelle 0x11fd8a0 im Speicher kopiert.
- Als nächstes wird der string "rocks" and den string "MC14" angefügt.
- Der input wird gelesen und mit per strncmp mit "MC14rock" verglichen.
