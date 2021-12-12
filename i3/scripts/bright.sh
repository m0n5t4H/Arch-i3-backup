#!/bin/bash

# You can call this script like this:
# $./bright.sh up
# $./bright.sh down

function get_brightness {
    xbacklight -get
}

function send_notification {
    DIR=`dirname "$0"`
    brightness=`get_brightness`
   # brightness=${brightness%%.*}
    # Make the bar with the special character  (it's not dash -) M>
    # https://en.wikipedia.org/wiki/Box-drawing_character
#bar=$(seq -s "─" $(($brightness/5)) | sed 's/[0-9]//g')
if [ "$brightness" = "0" ]; then
        icon_name="~/.config/dunst/icons/display-brightness-symbolic.svg"
dunstify "$brightness""      " -i "$icon_name" -t 2000 -h int:value:"$brightness" -h string:synchronous:"─" -r 555
    else
	if [  "$brightness" -lt "25" ]; then
	     icon_name="~/.config/dunst/icons/display-brightness-symbolic.svg"
dunstify "$brightness""     " -i "$icon_name" -r 555 -t 3000
    else
        if [ "$brightness" -lt "50" ]; then
            icon_name="~/.config/dunst/icons/display-brightness-symbolic.svg"
        else
            if [ "$brightness" -lt "85" ]; then
                icon_name="~/.config/dunst/icons/display-brightness-symbolic.svg"
            else
                icon_name="~/.config/dunst/icons/display-brightness-symbolic.svg"
            fi
        fi
    fi
fi
bar=$(seq -s "━" $(($brightness/5)) | sed 's/[0-9]//g')

let _progress=(${brightness}*100/100*100)/100
let _done=(${_progress})*2/10
let _left=20-$_done
# Build progressbar string lengths
_fill=$(printf "%${_done}s")
_empty=$(printf "%${_left}s")
build_bar="${_fill// /━}${_empty// /-}|"

# Send the notification
dunstify "$brightness""     " -i "$icon_name" -t 2000 -h int:value:"$brightness" -h string:synchronous:"$bar" -r 555

}

case $1 in
    up)
        xbacklight -inc 5
    send_notification
        ;;
    down)
    xbacklight -dec 5
        send_notification
	;;
esac

