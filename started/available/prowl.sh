#!/bin/bash
# Schickt eine Push-Nachricht via Prowl auf ein iOS-Gerät
# http://www.prowlapp.com
# http://www.prowlapp.com/static/prowl.pl
prowl.pl -apikey=$PROWL_KEY -priority=2 -application="Feuerwehr" -event="Neuer Alarm" -notification="Melder hat ausgelöst um $(date)"
