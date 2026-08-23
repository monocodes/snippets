#!/bin/bash
############## PUT IT INTO /volume1/docker/chrome/custom-cont-init.d

echo "[init] Executing pre-flight state cleanup for Chromium..."

# Define absolute paths within the container environment
PROFILE_DIR="/config/.config/chromium"
PREF_FILE="$PROFILE_DIR/Default/Preferences"

# Remove hard process locks that trigger the crash handler
rm -f "$PROFILE_DIR/SingletonLock"
rm -f "$PROFILE_DIR/SingletonCookie"
rm -f "$PROFILE_DIR/SingletonSocket"

# Patch the JSON configuration to simulate a graceful exit sequence
if [ -f "$PREF_FILE" ]; then
    sed -i "s/\"exited_cleanly\":false/\"exited_cleanly\":true/g" "$PREF_FILE"
    sed -i "s/\"exit_type\":\"Crashed\"/\"exit_type\":\"Normal\"/g" "$PREF_FILE"
    echo "[init] Exit flags successfully normalized."
else
    echo "[init] Preferences file not found. Skipping JSON patch."
fi
EOF'