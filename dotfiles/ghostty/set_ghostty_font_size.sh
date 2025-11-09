#!/bin/bash

# Get the main display's resolution.
# Note: This gets the resolution of the *main* display.
RESOLUTION=$(system_profiler SPDisplaysDataType | grep "Resolution" | awk '{print $2$3$4}')

# Path to the Ghostty config file
CONFIG_FILE="$HOME/.config/ghostty/config"

# --- Set font size based on resolution ---
# Built-in Retina display resolution
if [[ "$RESOLUTION" == "3024x1964" ]]; then
    NEW_FONT_SIZE=16
else
    # Assumed external monitor
    NEW_FONT_SIZE=14
fi

# Check if the font size needs to be changed to avoid unnecessary reloads
CURRENT_FONT_SIZE=$(grep '^font-size' "$CONFIG_FILE" | awk '{print $3}')

if [[ "$CURRENT_FONT_SIZE" == "$NEW_FONT_SIZE" ]]; then
    echo "Font size is already set to $NEW_FONT_SIZE. No changes needed."
    exit 0
fi

# --- Update the font size in the config file ---
# The `sed` command updates the `font-size` line in your config.
sed -i '' "s/^font-size = .*/font-size = $NEW_FONT_SIZE/" "$CONFIG_FILE"
echo "Ghostty font size set to $NEW_FONT_SIZE."

# --- Reload Ghostty using AppleScript ---
# This simulates the Cmd+Shift+, keystroke to trigger a config reload.
osascript -e '
    tell application "System Events"
        tell application process "ghostty"
            keystroke "," using {command down, shift down}
        end tell
    end tell
'
echo "Ghostty configuration reload triggered."