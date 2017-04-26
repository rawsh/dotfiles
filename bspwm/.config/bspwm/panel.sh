#! /bin/bash

PANEL_FIFO=/tmp/panel-fifo
PANEL_HEIGHT=36
#PANEL_FONT="-*-fixed-*-*-*-*-10-*-*-*-*-*-*-*"
PANEL_FONT="fira sans:size=11"
PANEL_WM_NAME=bspwm_panel
#export PANEL_FIFO PANEL_HEIGHT PANEL_FONT PANEL_WM_NAME


if xdo id -a "$PANEL_WM_NAME" > /dev/null ; then
	printf "%s\n" "The panel is already running." >&2
	exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

bspc config top_padding $PANEL_HEIGHT
bspc subscribe report > "$PANEL_FIFO" &
xtitle -sf 'T%s\n' > "$PANEL_FIFO" &
#{ echo "T"; echo "$(xtitle $(bspc query -N -n .window -d focused))"; } | sed ':a;N;s/\n/ || /;ba' > "$PANEL_FIFO" &
while :; do date +"S%A %d/%m %I:%M"; sleep 5 ; done > "$PANEL_FIFO" &

. panel_colors

. panel_bar < "$PANEL_FIFO" | lemonbar -a 36 -n "$PANEL_WM_NAME" -g x$PANEL_HEIGHT -f "$PANEL_FONT" -F "$COLOR_DEFAULT_FG" -B "$COLOR_DEFAULT_BG" | sh &

wid=$(xdo id -a "$PANEL_WM_NAME")
tries_left=20
while [ -z "$wid" -a "$tries_left" -gt 0 ] ; do
	sleep 0.05
	wid=$(xdo id -a "$PANEL_WM_NAME")
	tries_left=$((tries_left - 1))
done

[ -n "$wid" ] && xdo above -t "$(xdo id -N Bspwm -n root | sort | head -n 1)" "$wid"

wait
