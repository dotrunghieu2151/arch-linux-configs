#!/usr/bin/env bash

display=$1
wallpaper_path=$2

# Generate the new theme. This also runs the configured post-hooks.
matugen image "$wallpaper_path" -m dark --type scheme-smart --source-color-index 0
