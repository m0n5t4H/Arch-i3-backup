#!/bin/sh
case "$1" in
    --popup)
        dunstify -a App "CPU time (%)" "$(ps axch -o cmd:10,pcpu k -pcpu | head | awk '$0=$0"%"' )"
        ;;
    *)
        echo " "
        ;;
esac
