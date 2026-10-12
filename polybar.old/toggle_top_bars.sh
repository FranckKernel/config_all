#!/bin/bash

#"$HOME/.config/polybar/polykill_bar" bar0
#"$HOME/.config/polybar/polykill_bar" bar1
sleep 0.5
"$HOME/.config/polybar/polybar_toggle" bar0 &
"$HOME/.config/polybar/polybar_toggle" bar1
