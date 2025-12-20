#!/bin/bash

# Define the backlight device (use the exact device ID)
DEVICE="asus::kbd_backlight"

# Get the current maximum possible brightness
MAX_BRIGHTNESS=$(brightnessctl -d $DEVICE max)

# Get the current brightness level (value is 0-MAX_BRIGHTNESS)
CURRENT_BRIGHTNESS=$(brightnessctl -d $DEVICE get)

# Define the specific levels you want to use (adjust these as needed)
# Example: 10%, 50%, 100%, and Off (0)
# We will use simple counts 0, 1, 2, 3 to represent levels for simplicity in the script
LEVELS=(0 1 2 3) # Use 0 for off, and 1, 2, 3 for brightness levels

# Find the index of the current brightness in the LEVELS array
CURRENT_INDEX=-1
for i in "${!LEVELS[@]}"; do
   if [[ "${LEVELS[$i]}" == "$CURRENT_BRIGHTNESS" ]]; then
       CURRENT_INDEX=$i
       break
   fi
done

# Calculate the next index in the cycle
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#LEVELS[@]} ))

# Get the value for the next level
NEXT_LEVEL=${LEVELS[$NEXT_INDEX]}

# Execute the command to set the next level
# Note: For most systems, 'set' uses the actual value, not a percentage.
# If your levels are 1, 2, 3, 0, the script sets those values.
brightnessctl -d $DEVICE set $NEXT_LEVEL
