#!/bin/bash

# You can call this script like this:
# $./brightness.sh up
# $./brightness.sh down

# Based on sebastiencs' script (https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a)

function get_brightness {
    xbacklight -get
}

function send_notification {
    brightness=`get_brightness`
    brightness=${brightness%%.*}
    # Make the bar with the special character  (it's not dash -) Make sure it's not replaced by '?'
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "─" $(($brightness / 5)) | sed 's/[0-9]//g')
let _progress=(${brightness}*100/100*100)/100
let _done=(${_progress})*2/10
let _left=20-$_done
# Build progressbar string lengths
_fill=$(printf "%${_done}s")
_empty=$(printf "%${_left}s")
build_bar="${_fill// /━}${_empty// /-}|"


    #Send the notification
	case $brightness in
		100)
dunstify "$brightness""     ""$bar"  -i "$icon_name" -t 3000 -h int:value:"$brightness" -h string:synchronous:"$bar" -r 555
		#dunstify -i audio-brightness-muted-blocking -r 2593 -t 1000 -u normal "Brightness  $brightness:     $bar"
		;;
		*)
dunstify "$brightness""     ""$bar"  -i "$icon_name" -t 3000 -h int:value:"$brightness" -h string:synchronous:"$bar" -r 555
		#dunstify -i audio-brightness-muted-blocking -r 2593 -t 1000 -u normal "Brightness   $brightness:      $bar"
		;;
	esac
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
