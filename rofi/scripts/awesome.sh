#!/bin/bash
. "${HOME}/.cache/wal/colors.sh"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
UNICODE=`cat "$DIR"/unicode-list.txt | rofi "" -dmenu -nb $color0 -nf $color11 -sb $color1 -sf $color0 -i -markup-rows -p -columns 16 -width 100 -location 1 -lines 20 -bw 2 -yoffset -2 | cut -d\' -f2 | tail -c +4 | head -c -2`
printf '\u'$UNICODE | xclip -selection c
icon=`printf '\u'$UNICODE`
notify-send -t 2000 "$icon copied!"
