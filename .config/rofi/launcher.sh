#!/bin/bash
dir="$HOME/.config/rofi/themes"
theme="launcher"

rofi \
	-show drun \
	-show-icons \
	-theme ${dir}/${theme}.rasi
