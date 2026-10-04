#!/usr/bin/env bash

# Two screen landscape (Dad's)
xrandr \
	--output DP-1 --mode 1920x1080 --rate 144 --pos 0x0 --primary \
	--output HDMI-A-1 --mode 1920x1080 --rate 60 --pos 1920x0
