#!/bin/bash

blur=false 

while read line
do
	if [[ "$line" ==  *FI* ]]; then
		if [ "$blur" = true ]; then
			feh --bg-scale "/home/robert/Pictures/wallfab.jpg"
			blur=false
		fi
	else
		if [ "$blur" = false ]; then
			feh --bg-scale "/home/robert/Pictures/wallblur.jpg"
			blur=true
		fi
	fi
done < <(bspc subscribe)
