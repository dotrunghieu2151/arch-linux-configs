#!/bin/bash
dir="$HOME/.config/rofi/themes"
theme="clipboard-history"

cliphist list | rofi \
	-dmenu \
	-theme ${dir}/${theme}.rasi \
| cliphist decode | wl-copy
