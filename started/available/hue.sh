#!/bin/bash
# Stellt Philips Hue Lichter auf ein schwaches Blau.
# npm install -g hue-cli
echo '{"on":true, "bri": 200, "hue": 43680}' | hue lights all state
