#!/usr/bin/env bash

# Mom's 3-monitor layout - From working configuration
# DisplayPort-0: 2560x1440 primary (at 1920,0) @ 170Hz
# DisplayPort-1: 1920x1080 left (at 0,360) @ 144Hz
# HDMI-A-0: 1920x1080 right (at 4480,212) @ 60Hz

xrandr \
	--output DisplayPort-0 --mode 2560x1440 --rate 60 --pos 1920x0 --primary \
	--output DisplayPort-1 --mode 1920x1080 --rate 144 --pos 0x360 \
	--output HDMI-A-0 --mode 1920x1080 --rate 60 --pos 4480x212
