#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
IMAGE_PICKER_THEME="$HOME/.config/rofi/themes/wallpaper.rasi"
ROFI_MENU=""

WALLPAPER_FILES=$(find "$WALLPAPER_DIR" -type f \
        \( -iname '*.png' -o -iname '*.jpg' \
        -o -iname '*.jpeg' -o -iname '*.webp' \) |
    sort
) # add other like gif ...
CURRENT_WALLPAPER_FILE=$(basename $(wpaperctl get "DP-3"))
while IFS= read -r WALLPAPER_PATH; do
  WALLPAPER_NAME=$(basename "$WALLPAPER_PATH")
  if [[ "$WALLPAPER_NAME" == "$CURRENT_WALLPAPER_FILE" ]]; then
    ROFI_MENU+="${WALLPAPER_NAME} (current)\0icon\x1f${WALLPAPER_PATH}\n"
  else
    ROFI_MENU+="${WALLPAPER_NAME}\0icon\x1f${WALLPAPER_PATH}\n"
  fi
done <<<"$WALLPAPER_FILES"


SELECTED_WALLPAPER=$(echo -e "$ROFI_MENU" | PREVIEW=true rofi -dmenu \
  -p "Select Wallpaper:" \
  -theme "$IMAGE_PICKER_THEME"
)

# Apply the wallpaper to each connected monitor.
#
wpaperctl pause
wpaperctl set $WALLPAPER_DIR/$SELECTED_WALLPAPER
wpaperctl resume
