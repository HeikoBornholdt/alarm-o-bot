#!/bin/bash
# Dieses Skript schaltet eine Funksteckdose (siehe Pilight Konfiguration)
sudo pilight-send -S 127.0.0.1 -P 5000 -p elro_800_switch -s 31 -u 1 -t
