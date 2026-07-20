#!/bin/bash
############## PUT IT INTO /volume1/docker/chrome/custom-cont-init.d
PREF_FILE="/config/.config/chromium/Default/Preferences"
if [ -f "$PREF_FILE" ]; then
    echo "[mod] Forcing clean exit state in Chromium Preferences..."
    sed -i "s/\"exited_cleanly\":false/\"exited_cleanly\":true/g" "$PREF_FILE"
    sed -i "s/\"exit_type\":\"Crashed\"/\"exit_type\":\"Normal\"/g" "$PREF_FILE"
fi