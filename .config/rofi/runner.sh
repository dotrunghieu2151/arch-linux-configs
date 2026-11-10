#!/bin/bash
dir="$HOME/.config/rofi/themes"
theme="launcher"

rofi \
	-show run \
	-theme ${dir}/${theme}.rasi
