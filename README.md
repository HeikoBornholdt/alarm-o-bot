# Alarm-o-Bot

Dieses Bash-Skript führt in Verbindung mit einem Swissphone LGRA-Expert-Ladegerät und einen Raspberry Pi mit Raspbian bei Alarmierung bzw. Quittierung definierte Aufgaben durch.
Für folgende Aufgaben sind bereits Skripte vorhanden:

  * Schalte Philips hue-Lampen an.
  * Versende eine Push-Nachricht via Prowl auf das Smartphone.
  * Erstelle Foto vom Melder und versende dieses dann via E-Mail.

Das Ladegerät von Swissphone besitzt auf der Rückseite eine Buchse, mit welcher es möglich ist, über Alarmierungen bzw. Quittierungen benachrichtigt zu werden (siehe Seite 3, http://www.swissphone.com/wp-content/uploads/2013/11/MAN-psB14_ALGRA-Expert_DeEnFr_v1_0343235.pdf)

Die Verkabelung ist wie auf dem Schaltplan vorzunehmen
![Schaltplan](https://raw.githubusercontent.com/heikobornholdt/alarm-o-bot/master/Schaltplan.png)

Der Alarm-o-Bot kennt zwei Arten von Ereignissen:
## Start einer Alarmierung
Beim Start einer Alarmierung werden die Dateien `started/enabled/*.sh` ausgeführt.
Folgende Fälle werden als Start einer Alarmierung behandelt:

  * Wenn Melder in Ladestation, keine unquittierte Alarmierung vorhanden ist und dann eine neue Alarmierung empfangen wird.
  * Wenn der Melder mit unquittierten Alarmierungen in die Ladestation gesteckt wird.

Im Ordner `started/available` finden sich einige Beispiel-Skripte, welche per Symlink eingebunden werden können.

## Ende einer Alarmierung
Beim Ende einer Alarmierung werden die Dateien `ended/enabled/*.sh` ausgeführt.
Folgende Fälle werden als Ende einer Alarmierung behandelt:

  * Wenn der Melder mit unquittierten Alarmierungen aus der Ladestation entfernt wird.
  * Wenn der Melder in der Ladestation steckt und Alarmierungen quittiert werden.

Im Ordner `ended/available` finden sich einige Beispiel-Skripte, welche per Symlink eingebunden werden können.

# Installation & Benutzung

    # Lade Alarm-o-Bot herunter
    git clone git@github.com:heikobornholdt/alarm-o-bot.git
    # Falls Buchse an GPIO21 angeschlossen wurde, muss nach jedem Systemstart folgendes ausgeführt werden
	echo 21 > /sys/class/gpio/export
	# Alarm-o-Bot starten
    cd alarm-o-bot/
    ./alarm-o-bot.sh -i /sys/class/gpio/gpio21/value
