#!/bin/bash

blur=false #this blur variable is so we don't have to set the background every round

while read line
do
	if [[ "$line" ==  *FI* ]]; then
		if [ "$blur" = true ]; then
			feh --bg-scale "~/Pictures/wallfab.jpg" #non blurred wall
			blur=false
		fi
	else
		if [ "$blur" = false ]; then
			feh --bg-scale "~/Pictures/wallblur.jpg" #blurred wall
			blur=true
		fi
	fi
done < <(bspc subscribe) #subscribe to bspc (get notified of changes in windows)
