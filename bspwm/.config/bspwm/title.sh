#!/usr/bin/env bash
# takes input from `xtitle -s`, makes titles.
# determines monitor from $mon variable (set outside this script)
# todo: handle multiple title block separation better,
# investigate handling that at lemonade level/define delimiter.
# Neeasade


### OPTIONS ###

# only show the active window title at any time.
onlyShowActive=${p_title_only_show_active:-false}
# Maxium window title length
maxWinNameLen=${maxWinNameLen:-30}
# The delimiter to separate window sections
win_delim=${win_delim:-\|}
# The delimiter to separate the window name from the window in a window section.
win_id_delim=${win_id_delim:-//}


# not setting any settings if $onlyShowActive.
_meta="$(which meta)"
meta() {
    ! $onlyShowActive && eval $_meta "$*"
}

# set $1 length to $maxWinNameLen chars (trim or pad)
setLength() {
    content="$(echo "$1" | cut -c 1-$maxWinNameLen)"

    count=$(echo $content | wc -c)
    remain=$(( $maxWinNameLen - $count ))
    [ $(( $remain % 2 )) -ne 0 ] && remain=$(( $remain + 1 ))
    padding=
    for i in $(seq $(( $remain / 2))); do
        padding="$padding "
    done

    if $onlyShowActive; then
      meta bar_center_delimiter=""
      icon window
      meta bar_center_delimiter="$bar_center_delimiter"
      echo -n "$content";
    else
      echo -n "$padding$content$padding";
    fi
}

declare -A titleMap

doTheThing() {
    meta start
    active="$(bspc query -N -m $mon -n .focused.active || echo '')"

    if $onlyShowActive; then
      input="$(bspc query -N -n || echo '')"
    else
      input="$(bspc query -N -d $mon focused -n .window || echo '')"
    fi

    while read -r wid; do
        [[ -z "$wid" ]] && continue

        # fill in if empty
        [[ -z "${titleMap[$wid]}" ]] && titleMap[$wid]="$(setLength "$(xtitle $wid)")"

        # force refresh on active, set colors
        if [[ "$wid" = "$active" ]]; then
            titleMap[$wid]="$(setLength "$(xtitle $wid)")"
            meta actives
        fi

        # print
        [ ! -z "${titleMap[$wid]}" ] && echo "${titleMap[$wid]}"
        [[ "$wid" = "$active" ]] && meta reset

      done < <(echo "$input")

    # empty desktop case.
    [[ -z "$input" ]] && echo ""
    #meta
    #meta end
}

# initial fireoff:
doTheThing

while read -r trigger; do
    [[ ! "$mon" = "$(bspc query -M -m)" ]] && continue
    doTheThing
	echo "woot again"
done
