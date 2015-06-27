#!/bin/bash
# Schießt ein Foto und verschickt dieses via E-Mail
echo "Erstelle Foto..."
FILE=tmp/image${RANDOM}.jpg
raspistill -o $FILE --rotation 270 -v
echo "fertig!"

echo "Verschicke Foto..."
echo '' | mutt -a $FILE -s "Feuerwehr - Neuer Alarm" -- $PHOTO_RECIPIENT
echo "fertig!"
