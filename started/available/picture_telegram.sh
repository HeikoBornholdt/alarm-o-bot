#!/bin/bash
# Schießt ein Foto und verschickt dieses via Telegram
echo "Erstelle Foto..."
FILE=tmp/image${RANDOM}.jpg
raspistill -o $FILE --rotation 270 -v
echo "fertig!"

echo "Verschicke Foto..."
curl -F chat_id=$TELEGRAM_CHAT_ID -F photo=@"${FILE}" https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendPhoto
echo "fertig!"
