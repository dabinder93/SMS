#Übung 5 CTF
## Login with SSH
ssh -p 2200 level00@127.0.0.1
password: level00

## Level 00
Nach Ausführbaren Datei des Users flag00 gesucht und den output in eine Textdatei gepiped, welches die ganzen "Permission denied" nicht mitschreibt.

```
find /. -type f -executable -user flag00 >> output.txt
```

Danach die File aufgemacht, welches nur zwei Einträge hat.

![Alt text](A:\FH\WS17\SMS\Repo\Übung 5\Level00\level00_1.PNG?raw=true)
File ausgeführt:

![Alt text](A:\FH\WS17\SMS\Repo\Übung 5\Level00\level00_finish.PNG?raw=true)

##Level 01	
Idee:
getflag über echo aufrufen. Dazu nicht /bin/echo Befehl verwenden (weil man dafür keine Befugnis hat), sondern eigenes echo, welches im root Verzeichnis erstellt wurde und
```
/bin/getflag
```
ausführt.

Dazu wird für den auszuführenden Befehl der PATH auf unser Verzeichnis gesetzt, indem sich das neue echo befindet und anschließend das flag01 file, welches die Flagge captured ->
```
PATH=/home/level01 /home/flag01/flag01
```

![Alt text](A:\FH\WS17\SMS\Repo\Übung 5\Level01\level01_capture.PNG?raw=true)

##Level 02
Der
```
asprintf(&buffer, "/bin/echo %s is a nice MC student", getenv("USER"));
```
Befehl setzt an Stelle des **%s**, welches als Platzhalter dient, die Environment Variable **USER** ein.
Vorher stand **USER=level02**. Man kann nun an dieser stelle den getflag Befehl ausführen, indem man einen Shell escape macht.
Dieser sieht folgendermaßen aus:
```
export USER=\`/bin/getflag\`
```
Durch die **\`** wird der Inhalt Shell escaped, und führt somit /bin/getflag aus. Die **\\** sind wiederum zum escapen der **\`** verwendet.

![Alt text](A:\FH\WS17\SMS\Repo\Übung 5\Level02\level02_capture.PNG?raw=true)


##Level 03
Crontab wird alle 20 Sekunden ausgeführt.
Im writeable.sh skript gibt es eine Schleife, welche alle scripts, die sich im writeable.d Ordner befinden ausführt, und danach löscht.
-> Skript im writeable.d Ordner erstellt und dessen execute Berechtigung gegeben.
```
touch executeGetFlag.sh
```
In dieser File wird getflag ausgeführt und das Ergebnis in eine output.txt gepiped.
```
/bin/getflag >> output.txt
```
Berechtigung gegeben:
```
chmod 755 executeGetFlag.sh
```
Danach wurde das Skript automatisch nach 20 Sekunden ausgeführt und eine output.txt mit dem Ausgabetext, dass die Flagge gecaputed wurde, erstellt.

![Alt text](A:\FH\WS17\SMS\Repo\Übung 5\Level03\output.PNG?raw=true)

**output.txt Inhalt:**
![Alt text](A:\FH\WS17\SMS\Repo\Übung 5\Level03\capture.PNG?raw=true)

##Level 04
```
if(strstr(argv[1], "token") != NULL) {
```
Diese Zeile fragt nach dem Token File Namen. Da wir nicht "token" übergeben dürfen, erstellen wir einen link mit
```
ln token /home/level04/newlink
```
Somit haben wir einen Link von der File auf das Homeverzeichnis erstellt.
Als nächstes wird der Link als übergabe Parameter übergeben.
```
level04@smsctf:/home/flag04$ ./flag04 /home/level04/newlink
```
Somit wird die if Anfrage umgangen und die File ausgelesen.
Folgender String war die Ausgabe:
```
06508b5e-8909-4f38-b630-fdb148a848a2
```
Erster Gedanke war gleich, dies muss ein Passwort sein. Um getflag ausführen zu können braucht man eine Berechtigung, welche nur der flag04 User hat. Somit wurde das einloggen in das User Profil von flag04 mit dem oben erhaltenen String als Passworteingabe probiert.
```
level04@smsctf:/home/flag04$ su flag04
```
Dies war erfolgreich. Danach einfach getflag und die Flagge wurde gecaptured!

![Alt text](A:\FH\WS17\SMS\Repo\Übung 5\Level04\capture.PNG?raw=true)

##Level 05
Zuerst wurden keine Ordner, Files etc. angezeigt, weil diese versteckt waren.
Aufgefallen ist der .backup Ordner, welcher eine .tar File in sich hatte.
Diese konnte man wegen Berechtigungsgründung nicht entpacken, somit habe ich eine Kopie im /home/level05 Verzeichnis erstellt.
Das .tar Verzeichnis enthielt folgende Dateien:
![Alt text](A:\FH\WS17\SMS\Repo\Übung 5\Level05\tar_file.PNG?raw=true)

Als nächstes habe ich in den .ssh Ordner gewechselt und dort eine ssh Verbindung mit folgendem Befehl aufgebaut:
```
ssh -2 -v flag05@127.0.0.1
```
- -2 steht für Protokoll Typ 2, welches zum File identifizieren benötigt wird (für  ~/.ssh/id_rsa z.B)
- -v für mehr Textausgabe, was passiert.

![Alt text](A:\FH\WS17\SMS\Repo\Übung 5\Level05\capture.PNG?raw=true)

Somit habe ich mich zum Host verbunden und dort **getflag** ausgeführt!


