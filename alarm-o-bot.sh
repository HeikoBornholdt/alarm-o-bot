#!/bin/bash
########################################################################
#
# Dieses Skript liest sekündlich die Belegung eines gegebenen Pins aus. Der Wert
# beträgt im normafall 1 und wechselt bei einer Alarmierung auf 0.
# Sobald festgestellt wurde, dass eine Alarmierung stattfindet, werden alle
# *.sh-Dateien im Ordner ./started/enabled ausgeführt. Beim Ende einer
# Alarmierung werden alle *.sh-Dateien im Ordner ./ended/enabled ausgeführt.
# Außerdem werden jede Sekunde alle *.sh-Dateien im Ordner ./include/enabled
# ausgeführt. Somit ist es z.B. möglich, Daten aus externen Quellen im Vorfeld
# zu laden, damit diese bei einer Alarmierung sofort verfügbar sind.
#
# Eine Alarmierung kann wie folgt simuliert werden:
# $ svc -a /etc/service/alarm-o-bot
#
########################################################################

# erhalten Ordner dieses Skriptes
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

USAGE="Benutzung:\n-h\t\tZeigt diese Hilfe an\n-i string\tDatei zum Auslesen des Melder-Status (obligatorisch), z.B. /sys/class/gpio/gpio21/value\n";

if [ ! $# -ge 1 ]; then
  printf "Kein Argument angegeben.\n${USAGE}" >&2
  exit 2;
fi

while getopts ":hi::" Option; do
  case $Option in
    h )
        printf "$USAGE" $(basename $0);
        exit 0;
      ;;
    i )
        INPUT_GIVEN=1;
        INPUT=${OPTARG};
      ;;
    * ) # Default.
        printf "Unbekanntes Argument: -${OPTARG}\n${USAGE}" >&2
        exit 2;
      ;;
  esac
done

# Validiere Eingaben
if [ ! "$INPUT_GIVEN" ]; then
  printf "Keine Datei zum Auslesen des Melder-Status angeben.\n${USAGE}" >&2
  exit 2;
fi

# Prüfe, ob Status ausgelesen werden kann
LAST_STATUS=`cat $INPUT 2> /dev/null`
if [ ! "$?" = "0" ]; then
  echo "Datei existiert nicht oder kann nicht ausgelesen werden: ${INPUT}. Wurde der GPIO exportiert?" >&2
  exit 2;
fi

# Gebe aktuellen Status aus
echo -n "Beginne mit Überwachung des Status. Aktuell: "
if [ "$LAST_STATUS" = "1" ]; then
  echo 'Keine unquittieren Alarmierungen'
elif [ "$LAST_STATUS" = "0" ]; then
  echo 'Unquittiere Alarmierungen vorhanden!'
else
  echo "Unbekannt!? (${LAST_STATUS})"
fi

# Simuliere Alarmierung, bei SIGALRM
trap "SIMULATE_ALARM=1" SIGALRM

# Prüfe jede Sekunde, ob sich der Status geändert hat.
LAST_LAST_STATUS=$LAST_STATUS
while true; do
  # Prüft, ob es gerade einen Alarm gibt. Gibt 0 zurück, wenn dies der Fall ist.
  # Andernfalls 1.
  STATUS=`cat $INPUT`

  # Alarmierung wurde simuliert
  if [ "$SIMULATE_ALARM" = "1" ]; then
    unset SIMULATE_ALARM
    STATUS=0
    echo "Simuliere Alarmierung"
  fi

  if [ "$STATUS" = "0" ] && [ "$LAST_STATUS" = "1" ] && [ "$LAST_LAST_STATUS" = "1" ]; then
    # Alarmierung begonnen
    echo "Alarmierung gestartet: $(date)"
    for f in ${DIR}/started/enabled/*.sh; do source $f; done

  elif [ "$STATUS" = "1" ] && [ "$LAST_STATUS" = "1" ] && [ "$LAST_LAST_STATUS" = "0" ]; then
    # Es kam vor, dass wenn im Melder eine unquittierte Nachricht vorlag, dass der Melder
    # kurzeitig (nur wenige Hunderstel), auf 1 und dann wieder auf 0 sprang. Deswegen gucken
    # wir hier auch auf LAST_LAST_STATUS
    # Alarmierung beendet
    echo "Alarmierung beendet: $(date)"
    for f in ${DIR}/ended/enabled/*.sh; do source $f; done

  fi

  for f in ${DIR}/include/enabled/*.sh; do source $f; done

  LAST_LAST_STATUS=$LAST_STATUS
  LAST_STATUS=$STATUS
  sleep 0.25
done
