#!/bin/bash

blur=false 

while read line
do
	echo "$line"
	if [[ "$line" == *F* ]]; then
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
#    if [ $(bspc desktop -f) ]; then
#	    if [ "$blur" = true ]; then
#		    echo "noblur"
#		    feh --bg-tile "/home/robert/Pictures/wallnameofthewind.jpg"
#		    blur=false
#	    fi
#    else
#	    if [ "$blur" = false ]; then
#		    echo "blur"
#		    feh --bg-tile "/home/robert/Pictures/wallmountain.jpg"
#		    blur=true
#	    fi
#    fi
done < <(bspc subscribe)
